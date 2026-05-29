// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSessionAdapter extends TypeAdapter<GameSession> {
  @override
  final int typeId = 1;

  @override
  GameSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSession(
      id: fields[0] as String,
      playedAt: fields[1] as DateTime,
      playerIds: (fields[2] as List).cast<String>(),
      winnerId: fields[3] as String?,
      rounds: fields[4] as int,
      durationSeconds: fields[5] as int,
      turns: (fields[6] as List).cast<TurnRecord>(),
      startScore: fields[7] as int,
      winnerLastDart: fields[8] as String?,
      winnerDartsThrown: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playedAt)
      ..writeByte(2)
      ..write(obj.playerIds)
      ..writeByte(3)
      ..write(obj.winnerId)
      ..writeByte(4)
      ..write(obj.rounds)
      ..writeByte(5)
      ..write(obj.durationSeconds)
      ..writeByte(6)
      ..write(obj.turns)
      ..writeByte(7)
      ..write(obj.startScore)
      ..writeByte(8)
      ..write(obj.winnerLastDart)
      ..writeByte(9)
      ..write(obj.winnerDartsThrown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TurnRecordAdapter extends TypeAdapter<TurnRecord> {
  @override
  final int typeId = 2;

  @override
  TurnRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TurnRecord(
      playerId: fields[0] as String,
      roundNumber: fields[1] as int,
      dartLabels: (fields[2] as List).cast<String>(),
      total: fields[3] as int,
      remaining: fields[4] as int,
      bust: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TurnRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.roundNumber)
      ..writeByte(2)
      ..write(obj.dartLabels)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.remaining)
      ..writeByte(5)
      ..write(obj.bust);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TurnRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
