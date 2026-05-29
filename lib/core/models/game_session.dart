import 'package:hive_flutter/hive_flutter.dart';

part 'game_session.g.dart';

@HiveType(typeId: 1)
class GameSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime playedAt;

  @HiveField(2)
  List<String> playerIds;

  @HiveField(3)
  String? winnerId;

  @HiveField(4)
  int rounds;

  @HiveField(5)
  int durationSeconds;

  @HiveField(6)
  List<TurnRecord> turns;

  @HiveField(7)
  int startScore;

  @HiveField(8)
  String? winnerLastDart;

  @HiveField(9)
  int winnerDartsThrown;

  GameSession({
    required this.id,
    required this.playedAt,
    required this.playerIds,
    this.winnerId,
    required this.rounds,
    required this.durationSeconds,
    required this.turns,
    this.startScore = 301,
    this.winnerLastDart,
    this.winnerDartsThrown = 0,
  });
}

@HiveType(typeId: 2)
class TurnRecord extends HiveObject {
  @HiveField(0)
  String playerId;

  @HiveField(1)
  int roundNumber;

  @HiveField(2)
  List<String> dartLabels;

  @HiveField(3)
  int total;

  @HiveField(4)
  int remaining;

  @HiveField(5)
  bool bust;

  TurnRecord({
    required this.playerId,
    required this.roundNumber,
    required this.dartLabels,
    required this.total,
    required this.remaining,
    required this.bust,
  });
}
