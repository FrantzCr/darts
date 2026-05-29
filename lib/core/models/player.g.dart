// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 0;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[2] as String,
      hand: fields[3] as String,
      totalGames: fields[4] as int,
      totalWins: fields[5] as int,
      totalDarts: fields[6] as int,
      totalPoints: fields[7] as int,
      bestTurn: fields[8] as int,
      scores100plus: fields[9] as int,
      tons180: fields[10] as int,
      doubleAttempts: fields[11] as int,
      doubleHits: fields[12] as int,
      currentStreak: fields[13] as int,
      bestStreak: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.hand)
      ..writeByte(4)
      ..write(obj.totalGames)
      ..writeByte(5)
      ..write(obj.totalWins)
      ..writeByte(6)
      ..write(obj.totalDarts)
      ..writeByte(7)
      ..write(obj.totalPoints)
      ..writeByte(8)
      ..write(obj.bestTurn)
      ..writeByte(9)
      ..write(obj.scores100plus)
      ..writeByte(10)
      ..write(obj.tons180)
      ..writeByte(11)
      ..write(obj.doubleAttempts)
      ..writeByte(12)
      ..write(obj.doubleHits)
      ..writeByte(13)
      ..write(obj.currentStreak)
      ..writeByte(14)
      ..write(obj.bestStreak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
