import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:uuid/uuid.dart';

class BoardGenerator {
  static const int mediumSize = 28;

  static List<Tile> generateMediumBoard() {
    final List<Tile> tiles = [];
    final uuid = Uuid();

    for (int i = 0; i < mediumSize; i++) {
      if (i == 0) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'GO', type: TileType.go));
      } else if (i == 7) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'JAIL', type: TileType.jail));
      } else if (i == 14) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'FREE PARKING', type: TileType.parking));
      } else if (i == 21) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'GO TO JAIL', type: TileType.goToJail));
      } else if (i == 3 || i == 11 || i == 18 || i == 25) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'CHANCE', type: TileType.chance));
      } else if (i == 5 || i == 12) {
        tiles.add(ActionTile(id: uuid.v4(), name: 'TAX\n(\$100)', type: TileType.tax));
      } else {
        // Property tiles
        Color groupColor;
        int price;
        int rent;

        if (i < 7) {
          groupColor = Colors.brown;
          price = 100;
          rent = 10;
        } else if (i < 14) {
          groupColor = Colors.lightBlue;
          price = 150;
          rent = 15;
        } else if (i < 21) {
          groupColor = Colors.orange;
          price = 200;
          rent = 20;
        } else {
          groupColor = Colors.red;
          price = 250;
          rent = 25;
        }

        tiles.add(PropertyTile(
          id: uuid.v4(),
          name: 'P-$i',
          price: price,
          rent: rent,
          colorValue: groupColor.value,
        ));
      }
    }
    return tiles;
  }
}
