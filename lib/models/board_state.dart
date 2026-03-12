import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/providers/language_provider.dart';
import 'package:hive/hive.dart';

part 'board_state.g.dart';

@HiveType(typeId: 6)
class BoardState {
  @HiveField(0)
  final List<Player> players;
  @HiveField(1)
  final List<Tile> tiles;
  @HiveField(2, defaultValue: 0)
  final int currentPlayerIndex;
  @HiveField(3, defaultValue: 1500)
  final int initialMoney;
  @HiveField(4, defaultValue: 200)
  final int goSalary;

  @HiveField(5, defaultValue: <String>[])
  final List<String> logs;
  @HiveField(6, defaultValue: 'en')
  final String languageCode;

  BoardState({
    required this.players,
    required this.tiles,
    this.currentPlayerIndex = 0,
    this.initialMoney = 1500,
    this.goSalary = 200,
    this.logs = const [],
    this.languageCode = 'en',
  });

  BoardState copyWith({
    List<Player>? players,
    List<Tile>? tiles,
    int? currentPlayerIndex,
    int? initialMoney,
    int? goSalary,
    List<String>? logs,
    String? languageCode,
  }) {
    return BoardState(
      players: players ?? this.players,
      tiles: tiles ?? this.tiles,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      initialMoney: initialMoney ?? this.initialMoney,
      goSalary: goSalary ?? this.goSalary,
      logs: logs ?? this.logs,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Language get language => languageCode == 'vi' ? Language.vi : Language.en;

  Player get currentPlayer => players[currentPlayerIndex];
}
