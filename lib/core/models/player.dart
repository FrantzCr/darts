import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String colorHex;

  @HiveField(3)
  String hand; // 'left' | 'right'

  @HiveField(4)
  int totalGames;

  @HiveField(5)
  int totalWins;

  @HiveField(6)
  int totalDarts;

  @HiveField(7)
  int totalPoints;

  @HiveField(8)
  int bestTurn;

  @HiveField(9)
  int scores100plus;

  @HiveField(10)
  int tons180;

  @HiveField(11)
  int doubleAttempts;

  @HiveField(12)
  int doubleHits;

  @HiveField(13)
  int currentStreak;

  @HiveField(14)
  int bestStreak;

  Player({
    required this.id,
    required this.name,
    required this.colorHex,
    this.hand = 'right',
    this.totalGames = 0,
    this.totalWins = 0,
    this.totalDarts = 0,
    this.totalPoints = 0,
    this.bestTurn = 0,
    this.scores100plus = 0,
    this.tons180 = 0,
    this.doubleAttempts = 0,
    this.doubleHits = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return trimmed.substring(0, trimmed.length.clamp(1, 2)).toUpperCase();
  }

  Color get color => Color(int.parse('FF${colorHex.replaceAll('#', '')}', radix: 16));

  double get winRate => totalGames == 0 ? 0 : totalWins / totalGames;

  double get ppd => totalDarts == 0 ? 0 : totalPoints / totalDarts;

  double get doubleRate => doubleAttempts == 0 ? 0 : doubleHits / doubleAttempts;

  Player copyWith({
    String? name,
    String? colorHex,
    String? hand,
    int? totalGames,
    int? totalWins,
    int? totalDarts,
    int? totalPoints,
    int? bestTurn,
    int? scores100plus,
    int? tons180,
    int? doubleAttempts,
    int? doubleHits,
    int? currentStreak,
    int? bestStreak,
  }) => Player(
    id: id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    hand: hand ?? this.hand,
    totalGames: totalGames ?? this.totalGames,
    totalWins: totalWins ?? this.totalWins,
    totalDarts: totalDarts ?? this.totalDarts,
    totalPoints: totalPoints ?? this.totalPoints,
    bestTurn: bestTurn ?? this.bestTurn,
    scores100plus: scores100plus ?? this.scores100plus,
    tons180: tons180 ?? this.tons180,
    doubleAttempts: doubleAttempts ?? this.doubleAttempts,
    doubleHits: doubleHits ?? this.doubleHits,
    currentStreak: currentStreak ?? this.currentStreak,
    bestStreak: bestStreak ?? this.bestStreak,
  );
}
