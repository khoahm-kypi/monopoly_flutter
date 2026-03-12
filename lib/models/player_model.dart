import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'player_model.g.dart';

@HiveType(typeId: 0)
class Player {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int tokenColorValue;
  @HiveField(3)
  final int money;
  @HiveField(4)
  final int position;
  @HiveField(5)
  final bool isActive;
  @HiveField(6)
  final bool inJail;
  @HiveField(7, defaultValue: false)
  final bool isBot;

  Player({
    required this.id,
    required this.name,
    required this.tokenColorValue,
    this.money = 1500,
    this.position = 0,
    this.isActive = true,
    this.inJail = false,
    this.isBot = false,
  });

  Color get tokenColor => Color(tokenColorValue);

  Player copyWith({
    String? id,
    String? name,
    Color? tokenColor,
    int? money,
    int? position,
    bool? isActive,
    bool? inJail,
    bool? isBot,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      tokenColorValue: tokenColor?.value ?? this.tokenColorValue,
      money: money ?? this.money,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      inJail: inJail ?? this.inJail,
      isBot: isBot ?? this.isBot,
    );
  }
}
