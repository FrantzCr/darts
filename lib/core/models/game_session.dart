import 'package:cloud_firestore/cloud_firestore.dart';
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

  Map<String, dynamic> toFirestore() => {
    'playedAt': Timestamp.fromDate(playedAt),
    'playerIds': playerIds,
    'winnerId': winnerId,
    'rounds': rounds,
    'durationSeconds': durationSeconds,
    'startScore': startScore,
    'winnerLastDart': winnerLastDart,
    'winnerDartsThrown': winnerDartsThrown,
    'turns': turns.map((t) => {
      'playerId': t.playerId,
      'roundNumber': t.roundNumber,
      'dartLabels': t.dartLabels,
      'total': t.total,
      'remaining': t.remaining,
      'bust': t.bust,
    }).toList(),
  };

  static GameSession fromFirestore(String id, Map<String, dynamic> d) {
    final turns = (d['turns'] as List? ?? []).map((t) {
      final m = t as Map<String, dynamic>;
      return TurnRecord(
        playerId: m['playerId'] as String,
        roundNumber: (m['roundNumber'] as num).toInt(),
        dartLabels: (m['dartLabels'] as List).cast<String>(),
        total: (m['total'] as num).toInt(),
        remaining: (m['remaining'] as num).toInt(),
        bust: m['bust'] as bool? ?? false,
      );
    }).toList();
    return GameSession(
      id: id,
      playedAt: (d['playedAt'] as Timestamp).toDate(),
      playerIds: (d['playerIds'] as List).cast<String>(),
      winnerId: d['winnerId'] as String?,
      rounds: (d['rounds'] as num).toInt(),
      durationSeconds: (d['durationSeconds'] as num).toInt(),
      turns: turns,
      startScore: (d['startScore'] as num?)?.toInt() ?? 301,
      winnerLastDart: d['winnerLastDart'] as String?,
      winnerDartsThrown: (d['winnerDartsThrown'] as num?)?.toInt() ?? 0,
    );
  }
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
