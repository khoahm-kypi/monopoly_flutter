import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tile_model.g.dart';

@HiveType(typeId: 3)
enum TileType {
  @HiveField(0)
  go,
  @HiveField(1)
  property,
  @HiveField(2)
  chance,
  @HiveField(3)
  tax,
  @HiveField(4)
  jail,
  @HiveField(5)
  parking,
  @HiveField(6)
  goToJail,
}

abstract class Tile {
  final String id;
  final String name;
  final TileType type;

  Tile({
    required this.id,
    required this.name,
    required this.type,
  });
}

@HiveType(typeId: 4)
class PropertyTile extends Tile {
  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get name => super.name;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final int rent;

  @HiveField(4)
  final int colorValue;

  @HiveField(5)
  final String? ownerId;

  @HiveField(6, defaultValue: 0)
  final int houseCount;

  PropertyTile({
    required String id,
    required String name,
    required this.price,
    required this.rent,
    required this.colorValue,
    this.ownerId,
    this.houseCount = 0,
  }) : super(id: id, name: name, type: TileType.property);

  Color get colorGroup => Color(colorValue);

  int get currentRent => houseCount == 0 ? rent : rent * (2 * houseCount);
  int get upgradeCost => price ~/ 2;

  PropertyTile copyWith({
    String? ownerId,
    int? houseCount,
  }) {
    return PropertyTile(
      id: id,
      name: name,
      price: price,
      rent: rent,
      colorValue: colorValue,
      ownerId: ownerId ?? this.ownerId,
      houseCount: houseCount ?? this.houseCount,
    );
  }
}

@HiveType(typeId: 5)
class ActionTile extends Tile {
  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get name => super.name;

  @HiveField(2)
  @override
  TileType get type => super.type;

  ActionTile({
    required String id,
    required String name,
    required TileType type,
  }) : super(id: id, name: name, type: type);
}
