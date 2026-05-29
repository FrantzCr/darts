import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/active_game_state.dart';
import '../../../core/models/dart_throw.dart';
import '../../../core/models/game_session.dart';
import '../../../core/models/player.dart';
import '../../history/providers/history_provider.dart';
import '../../profile/providers/player_provider.dart';

class GameNotifier extends Notifier<ActiveGameState?> {
  @override
  ActiveGameState? build() => null;

  void startGame(List<Player> players, {int startScore = 301}) {
    state = ActiveGameState(
      players: players.map((p) => ActivePlayer(
        player: p,
        score: startScore,
        lastTurnLabels: [],
      )).toList(),
      startedAt: DateTime.now(),
    );
  }

  void recordHit(DartThrow dart) {
    final s = state;
    if (s == null || s.turnComplete || s.status == GameStatus.win) return;

    final newTurn = [...s.turn, dart];
    state = s.copyWith(
      turn: newTurn,
      lastHitId: dart.id,
      status: GameStatus.playing,
    );

    // Auto-validate when the dart brings score to exactly 0 on a double.
    final scored = newTurn.fold<int>(0, (sum, d) => sum + d.value);
    final newScore = s.me.score - scored;
    if (newScore == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (state != null && state!.status == GameStatus.playing) validate();
      });
      return;
    }

    // clear hit highlight after 420ms
    Future.delayed(const Duration(milliseconds: 420), () {
      if (state?.lastHitId == dart.id) {
        state = state?.copyWith(lastHitId: null);
      }
    });
  }

  void undo() {
    final s = state;
    if (s == null || s.turn.isEmpty) return;
    state = s.copyWith(turn: s.turn.sublist(0, s.turn.length - 1));
  }

  void validate() {
    final s = state;
    if (s == null) return;

    final cur = s.me;
    final scored = s.turnTotal;
    final newScore = cur.score - scored;
    final bust = newScore < 0;

    final doubleStats = _computeDoubleStats(s.turn, cur.score);

    final turnRecord = TurnRecord(
      playerId: cur.player.id,
      roundNumber: s.round,
      dartLabels: s.turn.map((d) => d.label).toList(),
      total: bust ? 0 : scored,
      remaining: bust ? cur.score : newScore,
      bust: bust,
    );

    final newTurns = [...s.completedTurns, turnRecord];
    final newAttempts = Map<String, int>.from(s.doubleAttemptsByPlayer);
    final newHits = Map<String, int>.from(s.doubleHitsByPlayer);
    newAttempts[cur.player.id] = (newAttempts[cur.player.id] ?? 0) + doubleStats.attempts;
    newHits[cur.player.id] = (newHits[cur.player.id] ?? 0) + doubleStats.hits;

    if (bust) {
      state = s.copyWith(
        status: GameStatus.bust,
        turn: [],
        completedTurns: newTurns,
        doubleAttemptsByPlayer: newAttempts,
        doubleHitsByPlayer: newHits,
      );
      Future.delayed(const Duration(milliseconds: 1800), () {
        final cur2 = state;
        if (cur2 != null) _advanceTurn(cur2, scored: 0, newScore: cur.score);
      });
      return;
    }

    final updatedPlayers = List<ActivePlayer>.from(s.players);
    updatedPlayers[s.activeIndex] = cur.copyWith(
      score: newScore,
      lastTurnLabels: s.turn.map((d) => d.label).toList(),
    );

    if (newScore == 0) {
      final winState = s.copyWith(
        players: updatedPlayers,
        status: GameStatus.win,
        turn: [],
        completedTurns: newTurns,
        doubleAttemptsByPlayer: newAttempts,
        doubleHitsByPlayer: newHits,
      );
      state = winState;
      _finalizeGame(winState);
      return;
    }

    _advanceTurn(
      s.copyWith(
        players: updatedPlayers,
        completedTurns: newTurns,
        doubleAttemptsByPlayer: newAttempts,
        doubleHitsByPlayer: newHits,
      ),
      scored: scored,
      newScore: newScore,
    );
  }

  void _advanceTurn(ActiveGameState s, {required int scored, required int newScore}) {
    final nextIndex = (s.activeIndex + 1) % s.players.length;
    final nextRound = nextIndex == 0 ? s.round + 1 : s.round;
    state = s.copyWith(
      activeIndex: nextIndex,
      turn: [],
      round: nextRound,
      status: GameStatus.playing,
    );
  }

  // Returns (attempts, hits) for this turn based on remaining score before each dart.
  ({int attempts, int hits}) _computeDoubleStats(List<DartThrow> darts, int startScore) {
    int attempts = 0;
    int hits = 0;
    int remaining = startScore;
    for (final dart in darts) {
      final isDoubleOut = (remaining <= 40 && remaining % 2 == 0 && remaining > 0) || remaining == 50;
      if (isDoubleOut) {
        attempts++;
        if (dart.multiplier == DartMultiplier.double && remaining - dart.value == 0) hits++;
      }
      remaining -= dart.value;
      if (remaining < 0) break;
    }
    return (attempts: attempts, hits: hits);
  }

  Future<void> _finalizeGame(ActiveGameState game) async {
    await ref.read(historyProvider.notifier).saveGame(game);

    final playerNotifier = ref.read(playerProvider.notifier);
    for (final ap in game.players) {
      final p = ap.player;
      final isWinner = ap.score == 0;
      final playerTurns = game.completedTurns.where((t) => t.playerId == p.id).toList();
      final validTurns = playerTurns.where((t) => !t.bust).toList();

      final dartsThrown = playerTurns.fold<int>(0, (sum, t) => sum + t.dartLabels.length);
      final pointsScored = validTurns.fold<int>(0, (sum, t) => sum + t.total);
      final bestThisTurn = validTurns.isEmpty ? 0 : validTurns.map((t) => t.total).reduce(max);
      final hundreds = validTurns.where((t) => t.total >= 100).length;
      final maxThrows = validTurns.where((t) => t.total == 180).length;

      final doubleAttempts = game.doubleAttemptsByPlayer[p.id] ?? 0;
      final doubleHits = game.doubleHitsByPlayer[p.id] ?? 0;

      final newStreak = isWinner ? p.currentStreak + 1 : 0;
      final newBestStreak = newStreak > p.bestStreak ? newStreak : p.bestStreak;

      await playerNotifier.updatePlayer(p.copyWith(
        totalGames: p.totalGames + 1,
        totalWins: p.totalWins + (isWinner ? 1 : 0),
        totalDarts: p.totalDarts + dartsThrown,
        totalPoints: p.totalPoints + pointsScored,
        bestTurn: bestThisTurn > p.bestTurn ? bestThisTurn : p.bestTurn,
        scores100plus: p.scores100plus + hundreds,
        tons180: p.tons180 + maxThrows,
        doubleAttempts: p.doubleAttempts + doubleAttempts,
        doubleHits: p.doubleHits + doubleHits,
        currentStreak: newStreak,
        bestStreak: newBestStreak,
      ));
    }
  }

  void reset() => state = null;
}

final gameProvider = NotifierProvider<GameNotifier, ActiveGameState?>(GameNotifier.new);
