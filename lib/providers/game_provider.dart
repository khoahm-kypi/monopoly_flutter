import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monopoly_ant/models/board_state.dart';
import 'package:monopoly_ant/providers/language_provider.dart';
import 'package:monopoly_ant/models/chance_card_model.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/core/utils/board_generator.dart';
import 'package:hive/hive.dart';
import 'dart:math';

final gameProvider = NotifierProvider<GameNotifier, BoardState>(() {
  return GameNotifier();
});

class GameNotifier extends Notifier<BoardState> {
  final Random _random = Random();
  late Box<BoardState> _saveBox;

  @override
  BoardState build() {
    _saveBox = Hive.box<BoardState>('game_save');
    
    // Check for saved game
    final savedGame = _saveBox.get('current_match');
    if (savedGame != null) {
      return savedGame;
    }

    return BoardState(
      players: [],
      tiles: BoardGenerator.generateMediumBoard(),
    );
  }

  void _save() {
    _saveBox.put('current_match', state);
  }

  void setupGame(List<Player> players, {int initialMoney = 1500, int goSalary = 200, Language language = Language.en}) {
    state = state.copyWith(
      players: players, 
      tiles: BoardGenerator.generateMediumBoard(),
      currentPlayerIndex: 0,
      initialMoney: initialMoney,
      goSalary: goSalary,
      languageCode: language == Language.vi ? 'vi' : 'en',
      logs: [
        AppStrings.get(language, 'log_start'),
        '${AppStrings.get(language, 'log_turn').replaceFirst('{name}', players[0].name)}'
      ],
    );
    _save();
  }

  void setLanguage(Language language) {
    state = state.copyWith(languageCode: language == Language.vi ? 'vi' : 'en');
    _save();
  }

  void resetGame() {
    _saveBox.delete('current_match');
    ref.invalidateSelf();
  }

  // Returns the dice result
  int rollDice() {
    int dice1 = _random.nextInt(6) + 1;
    int dice2 = _random.nextInt(6) + 1;
    int total = dice1 + dice2;
    return total;
  }

  Future<void> movePlayer(int steps) async {
    final player = state.currentPlayer;
    if (!player.isActive || player.inJail) {
      return;
    }

    int currentPosition = player.position;
    int currentMoney = player.money;

    for (int i = 0; i < steps; i++) {
      currentPosition++;
      if (currentPosition >= state.tiles.length) {
        currentPosition = 0;
        currentMoney += state.goSalary; // Passed GO
        addLog(AppStrings.get(state.language, 'log_pass_go', params: {
          'name': player.name,
          'amount': state.goSalary.toString(),
        }));
      }

      _updateCurrentPlayer(state.currentPlayer.copyWith(
        position: currentPosition,
        money: currentMoney,
      ));

      await Future.delayed(const Duration(milliseconds: 150));
    }

    // Check tile action after reaching destination
    final tile = state.tiles[currentPosition];
    bool enterJail = false;

    if (tile.type == TileType.goToJail) {
      currentPosition = 7; // Jail tile
      enterJail = true;
      _updateCurrentPlayer(state.currentPlayer.copyWith(
        position: currentPosition,
        inJail: enterJail,
      ));
    }
  }

  void payRent(PropertyTile property) {
    if (property.ownerId == null || property.ownerId == state.currentPlayer.id) return;

    final payer = state.currentPlayer;
    
    // Find owner
    final ownerIndex = state.players.indexWhere((p) => p.id == property.ownerId);
    if (ownerIndex == -1) return;
    final owner = state.players[ownerIndex];

    final updatedPlayers = List<Player>.from(state.players);
    
    int amountToPay = property.currentRent;
    bool isActive = true;
    int remainingMoney = payer.money - amountToPay;

    if (remainingMoney < 0) {
      isActive = false;
      amountToPay = payer.money; // Pay what they can before bankruptcy
    }

    updatedPlayers[state.currentPlayerIndex] = payer.copyWith(money: remainingMoney, isActive: isActive);
    updatedPlayers[ownerIndex] = owner.copyWith(money: owner.money + amountToPay);

    state = state.copyWith(players: updatedPlayers);
    addLog(AppStrings.get(state.language, 'log_pay_rent', params: {
      'name': payer.name,
      'amount': amountToPay.toString(),
      'owner': owner.name,
    }));

    if (!isActive) {
      addLog(AppStrings.get(state.language, 'log_bankrupt', params: {'name': payer.name}));
      _handleBankruptcy(payer.id);
    }
  }

  void buyProperty(PropertyTile property) {
    final player = state.currentPlayer;
    if (player.money >= property.price) {
      _updateCurrentPlayer(player.copyWith(money: player.money - property.price));
      
      final updatedTiles = List<Tile>.from(state.tiles);
      final tileIndex = updatedTiles.indexWhere((t) => t.id == property.id);
      
      if (tileIndex != -1) {
        updatedTiles[tileIndex] = property.copyWith(ownerId: player.id);
        state = state.copyWith(tiles: updatedTiles);
        addLog(AppStrings.get(state.language, 'log_buy', params: {
          'name': player.name,
          'property': property.name,
          'price': property.price.toString(),
        }));
      }
    }
  }

  void upgradeProperty(PropertyTile property) {
    final player = state.currentPlayer;
    if (player.money >= property.upgradeCost) {
      _updateCurrentPlayer(player.copyWith(money: player.money - property.upgradeCost));
      
      final updatedTiles = List<Tile>.from(state.tiles);
      final tileIndex = updatedTiles.indexWhere((t) => t.id == property.id);
      
      if (tileIndex != -1) {
        updatedTiles[tileIndex] = property.copyWith(houseCount: property.houseCount + 1);
        state = state.copyWith(tiles: updatedTiles);
        addLog(AppStrings.get(state.language, 'log_upgrade', params: {
          'name': player.name,
          'property': property.name,
          'level': (property.houseCount + 1).toString(),
        }));
      }
    }
  }

  void payTax(int amount) {
    final player = state.currentPlayer;
    bool isActive = true;
    int remainingMoney = player.money - amount;

    if (remainingMoney < 0) {
      isActive = false;
    }

    _updateCurrentPlayer(player.copyWith(money: remainingMoney, isActive: isActive));
    addLog(AppStrings.get(state.language, 'log_tax', params: {
      'name': player.name,
      'amount': amount.toString(),
    }));

    if (!isActive) {
      addLog(AppStrings.get(state.language, 'log_bankrupt_tax', params: {'name': player.name}));
      _handleBankruptcy(player.id);
    }
  }

  ChanceCard drawChanceCard() {
    final cards = ChanceDeck.defaultCards;
    return cards[_random.nextInt(cards.length)];
  }

  Future<void> applyChanceCard(ChanceCard card) async {
    final player = state.currentPlayer;
    switch (card.effectType) {
      case ChanceEffectType.addMoney:
        _updateCurrentPlayer(player.copyWith(money: player.money + card.value));
        break;
      case ChanceEffectType.subtractMoney:
        payTax(card.value);
        break;
      case ChanceEffectType.moveTo:
        final targetPos = card.value;
        int steps = targetPos - player.position;
        if (steps < 0) steps += state.tiles.length;
        addLog(AppStrings.get(state.language, 'log_chance_move', params: {'name': player.name}));
        await movePlayer(steps); // movePlayer already await Future.delayed
        break;
    }
    addLog(AppStrings.get(state.language, 'log_chance_result', params: {
      'desc': AppStrings.get(state.language, 'chance_${card.id}')
    }));
  }

  void _handleBankruptcy(String playerId) {
    // Return properties to bank
    final updatedTiles = state.tiles.map((t) {
      if (t is PropertyTile && t.ownerId == playerId) {
        return t.copyWith(ownerId: null); // Reset owner using null
      }
      return t;
    }).toList();

    state = state.copyWith(tiles: updatedTiles);
    _save();
  }

  void endTurn() {
    int nextIndex = (state.currentPlayerIndex + 1) % state.players.length;
    // Skip bankrupt players
    int attempts = 0;
    while (!state.players[nextIndex].isActive && attempts < state.players.length) {
      nextIndex = (nextIndex + 1) % state.players.length;
      attempts++;
    }
    state = state.copyWith(currentPlayerIndex: nextIndex);
    addLog(AppStrings.get(state.language, 'log_turn', params: {'name': state.players[nextIndex].name}));
    _save();
  }

  void addLog(String message) {
    final updatedLogs = List<String>.from(state.logs);
    updatedLogs.add(message);
    // Keep only last 100 logs for performance
    if (updatedLogs.length > 100) {
      updatedLogs.removeAt(0);
    }
    state = state.copyWith(logs: updatedLogs);
    _save();
  }

  void _updateCurrentPlayer(Player updatedPlayer) {
    final updatedPlayers = List<Player>.from(state.players);
    updatedPlayers[state.currentPlayerIndex] = updatedPlayer;
    state = state.copyWith(players: updatedPlayers);
    _save();
  }

  bool isGameOver() {
    return state.players.where((p) => p.isActive).length <= 1;
  }

  void releaseFromJail() {
    final player = state.currentPlayer;
    if (player.inJail) {
      _updateCurrentPlayer(player.copyWith(inJail: false));
      addLog(AppStrings.get(state.language, 'log_release_jail', params: {'name': player.name}));
      endTurn();
    }
  }
}
