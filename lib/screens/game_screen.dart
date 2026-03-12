import 'package:monopoly_ant/utils/tile_action_handlers.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monopoly_ant/providers/game_provider.dart';
import 'package:monopoly_ant/widgets/board_widget.dart';
import 'package:monopoly_ant/widgets/player_panel_widget.dart';
import 'package:monopoly_ant/widgets/game_log_widget.dart';
import 'package:monopoly_ant/screens/setup_screen.dart';
import 'package:monopoly_ant/providers/language_provider.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _lastDiceRoll;
  bool _isRolling = false;

  void _onDiceRolled() async {
    if (_isRolling) return;
    
    final notifier = ref.read(gameProvider.notifier);
    final stateBefore = ref.read(gameProvider);
    final playerBefore = stateBefore.currentPlayer;

    if (playerBefore.inJail) {
      notifier.releaseFromJail();
      return;
    }

    setState(() {
      _isRolling = true;
    });

    // Dice animation loop
    for (int i = 0; i < 6; i++) {
      setState(() {
        _lastDiceRoll = 1 + (DateTime.now().millisecondsSinceEpoch % 12);
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final result = notifier.rollDice();
    setState(() {
      _lastDiceRoll = result;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) {
      setState(() { _isRolling = false; });
      return;
    }

    await notifier.movePlayer(result);
    // Wait for the final piece movement animation to settle
    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    final state = ref.read(gameProvider);
    final player = state.currentPlayer;
    final currentTile = state.tiles[player.position];

    if (currentTile is PropertyTile) {
      final property = currentTile; // Create local variable for type promotion closure
      if (property.ownerId == null) {
        if (player.isBot) {
          if (player.money >= property.price) {
            notifier.buyProperty(property);
          }
          notifier.endTurn();
          if (mounted) setState(() { _isRolling = false; });
          return;
        }

        // Unowned property - prompt to buy
        if (player.money >= property.price) {
          TileActionHandlers.showBuyPropertyDialog(
            context,
            property,
            state.language,
            () { // onBuy
              notifier.buyProperty(property);
              notifier.endTurn();
              if (mounted) setState(() { _isRolling = false; });
            },
            () { // onSkip
              notifier.endTurn();
              if (mounted) setState(() { _isRolling = false; });
            },
          );
          return; // endTurn is called inside the callbacks
        } else {
          notifier.addLog(AppStrings.get(state.language, 'log_insufficient_funds', params: {
            'name': player.name,
            'property': property.name,
          }));
        }
      } else if (property.ownerId == player.id) {
        if (player.isBot) {
          if (player.money >= property.upgradeCost * 2 && property.houseCount < 4) {
            notifier.upgradeProperty(property);
          }
          notifier.endTurn();
          if (mounted) setState(() { _isRolling = false; });
          return;
        }

        // Owned by current player, prompt to upgrade
        if (player.money >= property.upgradeCost && property.houseCount < 4) {
          TileActionHandlers.showUpgradePropertyDialog(
            context,
            property,
            state.language,
            () { // onUpgrade
              notifier.upgradeProperty(property);
              notifier.endTurn();
              if (mounted) setState(() { _isRolling = false; });
            },
            () { // onSkip
              notifier.endTurn();
              if (mounted) setState(() { _isRolling = false; });
            },
          );
          return;
        }
      } else if (property.ownerId != player.id) {
        // Owned by someone else - pay rent
        notifier.payRent(property);
      }
    } else if (currentTile.type == TileType.tax) {
      notifier.payTax(100);
    } else if (currentTile.type == TileType.chance) {
      final card = notifier.drawChanceCard();
      if (player.isBot) {
        await notifier.applyChanceCard(card);
        notifier.endTurn();
        if (mounted) setState(() { _isRolling = false; });
        return;
      }
      
      TileActionHandlers.showChanceCardDialog(context, card, state.language, () async {
        await notifier.applyChanceCard(card);
        notifier.endTurn();
        if (mounted) setState(() { _isRolling = false; });
      });
      return;
    } else if (currentTile.type == TileType.goToJail) {
      // Logic handled in movePlayer and GameNotifier
    } else if (currentTile.type == TileType.jail) {
      // Visit
    } else if (currentTile.type == TileType.parking) {
      // Parking
    } else if (currentTile.type == TileType.go) {
      // Go
    }

    notifier.endTurn();
    if (mounted) {
      setState(() { _isRolling = false; });
    }
  }

  void _showFullLogs() {
    final logs = ref.read(gameProvider).logs;
    
    // Group logs by turn
    List<_TurnGroup> turnGroups = [];
    _TurnGroup? currentGroup;
    
    final boardState = ref.read(gameProvider);
    final language = boardState.language;
    
    for (final log in logs) {
      if (log.startsWith('[TURN]')) {
        currentGroup = _TurnGroup(log.replaceFirst('[TURN] ', ''));
        turnGroups.add(currentGroup);
      } else if (currentGroup != null) {
        currentGroup.actions.add(log);
      } else {
        // Log before turn started
        turnGroups.add(_TurnGroup(AppStrings.get(language, 'system'))..actions.add(log));
      }
    }
    
    // Reverse to show latest turns first
    final reversedGroups = turnGroups.reversed.toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(language, 'game_history')),
        content: SizedBox(
          width: 450,
          height: 600,
          child: ListView.builder(
            itemCount: reversedGroups.length,
            itemBuilder: (context, index) {
              final group = reversedGroups[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.blueGrey.shade100,
                    child: Text(
                      AppStrings.get(language, 'turn_of', params: {'name': group.playerName}),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  if (group.actions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(AppStrings.get(language, 'no_actions'), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ...group.actions.map((action) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.chevron_right, size: 14, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            Expanded(child: Text(action, style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      )),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(language, 'close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boardState = ref.watch(gameProvider);
    
    ref.listen(gameProvider, (prev, next) {
      if ((prev == null || prev.currentPlayerIndex != next.currentPlayerIndex) &&
          next.currentPlayer.isBot && 
          next.currentPlayer.isActive) {
        // Prevent multiple simultaneous bot triggers
        if (_isRolling) return;
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && !_isRolling) {
             // Second check inside delay to be safe
             final currentState = ref.read(gameProvider);
             if (currentState.currentPlayer.isBot && currentState.currentPlayer.isActive) {
                _onDiceRolled();
             }
          }
        });
      }
    });

    final players = boardState.players;

    if (players.isEmpty) return const SizedBox.shrink();

    final leftPlayers = players.take(2).toList();
    final rightPlayers = players.skip(2).toList();
    final currentPlayer = boardState.currentPlayer;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SetupScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(gameProvider.notifier).resetGame();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SetupScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
                // Left Panel
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: leftPlayers.length,
                          itemBuilder: (context, index) {
                            final player = leftPlayers[index];
                            final originalIndex = index;
                            return PlayerPanelWidget(
                              player: player,
                              isCurrentTurn: boardState.currentPlayerIndex == originalIndex,
                              language: boardState.language,
                              ownedProperties: boardState.tiles
                                  .whereType<PropertyTile>()
                                  .where((t) => t.ownerId == player.id)
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameLogWidget(
                          logs: boardState.logs,
                          currentPlayerName: currentPlayer.name,
                          language: boardState.language,
                          onShowAll: _showFullLogs,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Center Board
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: BoardWidget(
                          tiles: boardState.tiles,
                          players: players,
                          centerWidget: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_lastDiceRoll != null)
                                  Text(
                                    '🎲 $_lastDiceRoll',
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    backgroundColor: _isRolling ? Colors.grey : currentPlayer.tokenColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: _isRolling ? null : _onDiceRolled,
                                  child: Text(AppStrings.get(boardState.language, 'roll_dice'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${currentPlayer.name}${AppStrings.get(boardState.language, 'turn_suffix')}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Panel
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: rightPlayers.length,
                    itemBuilder: (context, index) {
                      final player = rightPlayers[index];
                      final originalIndex = index + 2;
                      return PlayerPanelWidget(
                        player: player,
                        isCurrentTurn: boardState.currentPlayerIndex == originalIndex,
                        language: boardState.language,
                        ownedProperties: boardState.tiles
                            .whereType<PropertyTile>()
                            .where((t) => t.ownerId == player.id)
                            .toList(),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _TurnGroup {
  final String playerName;
  final List<String> actions = [];
  _TurnGroup(this.playerName);
}
