// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardStateAdapter extends TypeAdapter<BoardState> {
  @override
  final int typeId = 6;

  @override
  BoardState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardState(
      players: (fields[0] as List).cast<Player>(),
      tiles: (fields[1] as List).cast<Tile>(),
      currentPlayerIndex: fields[2] == null ? 0 : fields[2] as int,
      initialMoney: fields[3] == null ? 1500 : fields[3] as int,
      goSalary: fields[4] == null ? 200 : fields[4] as int,
      logs: fields[5] == null ? [] : (fields[5] as List).cast<String>(),
      languageCode: fields[6] == null ? 'en' : fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BoardState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.players)
      ..writeByte(1)
      ..write(obj.tiles)
      ..writeByte(2)
      ..write(obj.currentPlayerIndex)
      ..writeByte(3)
      ..write(obj.initialMoney)
      ..writeByte(4)
      ..write(obj.goSalary)
      ..writeByte(5)
      ..write(obj.logs)
      ..writeByte(6)
      ..write(obj.languageCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
