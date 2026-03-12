import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/providers/game_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GameNotifier Unit Tests', () {
    late ProviderContainer container;
    
    setUpAll(() async {
      // Setup mock hive or use temporary path if needed
      // For basic unit tests of logic, we might need to mock the Box
    });

    setUp(() {
      container = ProviderContainer();
    });

    test('Initial game state should be empty', () {
      final state = container.read(gameProvider);
      expect(state.players, isEmpty);
      expect(state.currentPlayerIndex, 0);
    });

    test('setupGame should initialize players correctly', () {
      final players = [
        Player(id: '1', name: 'Player 1', colorValue: 0xFFFF0000),
        Player(id: '2', name: 'Player 2', colorValue: 0xFF00FF00),
      ];

      container.read(gameProvider.notifier).setupGame(players);

      final state = container.read(gameProvider);
      expect(state.players.length, 2);
      expect(state.players[0].name, 'Player 1');
      expect(state.players[1].name, 'Player 2');
      expect(state.currentPlayerIndex, 0);
    });

    test('buyProperty should deduct money and set owner', () {
      final player = Player(id: '1', name: 'Player 1', colorValue: 0xFFFF0000, money: 1500);
      final property = PropertyTile(
        id: 'prop-1',
        name: 'Test Property',
        price: 200,
        rent: 20,
        colorValue: 0xFF0000FF,
      );

      final notifier = container.read(gameProvider.notifier);
      notifier.setupGame([player]);
      
      // Inject property into state manually for test or use board generator
      // For simplicity, let's just test the logic if buyProperty is called
      notifier.buyProperty(property);

      final state = container.read(gameProvider);
      expect(state.players[0].money, 1300);
      
      final boughtTile = state.tiles.firstWhere((t) => t.name == property.name) as PropertyTile;
      expect(boughtTile.ownerId, '1');
    });

    test('endTurn should increment currentPlayerIndex', () {
      final players = [
        Player(id: '1', name: '1', colorValue: 0),
        Player(id: '2', name: '2', colorValue: 0),
      ];
      
      final notifier = container.read(gameProvider.notifier);
      notifier.setupGame(players);
      
      notifier.endTurn();
      
      expect(container.read(gameProvider).currentPlayerIndex, 1);
    });
  });
}
