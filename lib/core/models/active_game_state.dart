import 'dart_throw.dart';
import 'game_session.dart';
import 'player.dart';

class ActivePlayer {
  final Player player;
  final int score;
  final List<String> lastTurnLabels;

  const ActivePlayer({
    required this.player,
    required this.score,
    required this.lastTurnLabels,
  });

  ActivePlayer copyWith({int? score, List<String>? lastTurnLabels}) => ActivePlayer(
    player: player,
    score: score ?? this.score,
    lastTurnLabels: lastTurnLabels ?? this.lastTurnLabels,
  );
}

enum GameStatus { playing, bust, win }

class ActiveGameState {
  final List<ActivePlayer> players;
  final int activeIndex;
  final List<DartThrow> turn; // max 3 darts
  final String? lastHitId;
  final GameStatus status;
  final int round;
  final DateTime startedAt;
  final List<TurnRecord> completedTurns;
  final Map<String, int> doubleAttemptsByPlayer;
  final Map<String, int> doubleHitsByPlayer;

  const ActiveGameState({
    required this.players,
    this.activeIndex = 0,
    this.turn = const [],
    this.lastHitId,
    this.status = GameStatus.playing,
    this.round = 1,
    required this.startedAt,
    this.completedTurns = const [],
    this.doubleAttemptsByPlayer = const {},
    this.doubleHitsByPlayer = const {},
  });

  ActivePlayer get me => players[activeIndex];

  int get turnTotal => turn.fold(0, (s, d) => s + d.value);

  int get projected => me.score - turnTotal;

  bool get willBust => projected < 0;

  bool get turnComplete => turn.length >= 3;

  ActiveGameState copyWith({
    List<ActivePlayer>? players,
    int? activeIndex,
    List<DartThrow>? turn,
    String? lastHitId,
    GameStatus? status,
    int? round,
    List<TurnRecord>? completedTurns,
    Map<String, int>? doubleAttemptsByPlayer,
    Map<String, int>? doubleHitsByPlayer,
  }) => ActiveGameState(
    players: players ?? this.players,
    activeIndex: activeIndex ?? this.activeIndex,
    turn: turn ?? this.turn,
    lastHitId: lastHitId,
    status: status ?? this.status,
    round: round ?? this.round,
    startedAt: startedAt,
    completedTurns: completedTurns ?? this.completedTurns,
    doubleAttemptsByPlayer: doubleAttemptsByPlayer ?? this.doubleAttemptsByPlayer,
    doubleHitsByPlayer: doubleHitsByPlayer ?? this.doubleHitsByPlayer,
  );
}
