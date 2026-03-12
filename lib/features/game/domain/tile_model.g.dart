// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyTileAdapter extends TypeAdapter<PropertyTile> {
  @override
  final int typeId = 4;

  @override
  PropertyTile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyTile(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as int,
      rent: fields[3] as int,
      colorValue: fields[4] as int,
      ownerId: fields[5] as String?,
      houseCount: fields[6] == null ? 0 : fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyTile obj) {
    writer
      ..writeByte(7)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.rent)
      ..writeByte(4)
      ..write(obj.colorValue)
      ..writeByte(5)
      ..write(obj.ownerId)
      ..writeByte(6)
      ..write(obj.houseCount)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyTileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActionTileAdapter extends TypeAdapter<ActionTile> {
  @override
  final int typeId = 5;

  @override
  ActionTile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionTile(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as TileType,
    );
  }

  @override
  void write(BinaryWriter writer, ActionTile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionTileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TileTypeAdapter extends TypeAdapter<TileType> {
  @override
  final int typeId = 3;

  @override
  TileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TileType.go;
      case 1:
        return TileType.property;
      case 2:
        return TileType.chance;
      case 3:
        return TileType.tax;
      case 4:
        return TileType.jail;
      case 5:
        return TileType.parking;
      case 6:
        return TileType.goToJail;
      default:
        return TileType.go;
    }
  }

  @override
  void write(BinaryWriter writer, TileType obj) {
    switch (obj) {
      case TileType.go:
        writer.writeByte(0);
        break;
      case TileType.property:
        writer.writeByte(1);
        break;
      case TileType.chance:
        writer.writeByte(2);
        break;
      case TileType.tax:
        writer.writeByte(3);
        break;
      case TileType.jail:
        writer.writeByte(4);
        break;
      case TileType.parking:
        writer.writeByte(5);
        break;
      case TileType.goToJail:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
