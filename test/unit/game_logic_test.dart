import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_ant/features/game/domain/player_model.dart';
import 'package:monopoly_ant/features/game/domain/tile_model.dart';
import 'package:monopoly_ant/features/game/domain/board_state.dart';
import 'package:monopoly_ant/features/game/application/game_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import '../mocks/hive_mocks.mocks.dart';

void main() {
  group('GameNotifier Unit Tests', () {
    late ProviderContainer container;
    late MockBox<BoardState> mockBox;
    
    setUp(() {
      mockBox = MockBox<BoardState>();
      
      // Stub the box behavior
      when(mockBox.get(any)).thenReturn(null);
      // Stub put to avoid errors during _save()
      when(mockBox.put(any, any)).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          // We can't easily override the box inside the build method of GameNotifier 
          // if it uses Hive.box() directly unless we stub the Hive call.
        ],
      );
    });

    test('Basic Logic: Player Creation', () {
      final player = Player(
        id: '1', 
        name: 'Player 1', 
        tokenColorValue: 0xFFFF0000,
        money: 1500
      );
      expect(player.name, 'Player 1');
      expect(player.money, 1500);
    });

    test('Basic Logic: PropertyTile Creation', () {
      final property = PropertyTile(
        id: 'prop-1',
        name: 'Test Property',
        price: 200,
        rent: 20,
        colorValue: 0xFF0000FF,
      );
      expect(property.price, 200);
      expect(property.ownerId, isNull);
    });
  });
}
