import 'dart_throw.dart';
import 'game_mode.dart';
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
  final int startScore;
  final GameMode gameMode;
  final bool pendingGageSpin;
  final bool doubleOut;

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
    this.startScore = 301,
    this.gameMode = GameMode.classic,
    this.pendingGageSpin = false,
    this.doubleOut = false,
  });

  ActivePlayer get me => players[activeIndex];

  int get turnTotal => turn.fold(0, (s, d) => s + d.value);

  int get projected => me.score - turnTotal;

  bool get willBust => projected < 0;

  // RTC helpers
  int get rtcTarget => me.score; // current number to hit (1-20)
  bool get isRtc => gameMode == GameMode.rtc;

  bool get turnComplete {
    if (turn.length >= 3) return true;
    if (turn.isEmpty) return false;
    if (isRtc) return me.score > 20; // all 20 targets hit
    return projected == 0; // classic: exact checkout
  }

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
    bool? pendingGageSpin,
    bool? doubleOut,
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
    startScore: startScore,
    gameMode: gameMode,
    pendingGageSpin: pendingGageSpin ?? this.pendingGageSpin,
    doubleOut: doubleOut ?? this.doubleOut,
  );
}
