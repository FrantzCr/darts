import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/active_game_state.dart';
import '../../../core/models/game_session.dart';

const _boxName = 'game_sessions';

class HistoryNotifier extends Notifier<List<GameSession>> {
  @override
  List<GameSession> build() {
    final box = Hive.box<GameSession>(_boxName);
    return box.values.toList().reversed.toList();
  }

  Future<void> saveGame(ActiveGameState game) async {
    final winner = game.isRtc
        ? game.players.where((p) => p.score > 20).firstOrNull
        : game.players.where((p) => p.score == 0).firstOrNull;

    final winnerTurns = winner == null
        ? <TurnRecord>[]
        : game.completedTurns.where((t) => t.playerId == winner.player.id).toList();
    final winnerDartsThrown = winnerTurns.fold<int>(0, (s, t) => s + t.dartLabels.length);
    final winnerLastDart = winnerTurns.isEmpty ? null : winnerTurns.last.dartLabels.lastOrNull;

    final session = GameSession(
      id: const Uuid().v4(),
      playedAt: DateTime.now(),
      playerIds: game.players.map((p) => p.player.id).toList(),
      winnerId: winner?.player.id,
      rounds: game.round,
      durationSeconds: DateTime.now().difference(game.startedAt).inSeconds,
      turns: game.completedTurns,
      startScore: game.isRtc ? 0 : game.startScore,
      winnerLastDart: winnerLastDart,
      winnerDartsThrown: winnerDartsThrown,
    );
    final box = Hive.box<GameSession>(_boxName);
    await box.put(session.id, session);
    state = box.values.toList().reversed.toList();
  }

  GameSession? findById(String id) {
    return state.where((s) => s.id == id).firstOrNull;
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<GameSession>>(HistoryNotifier.new);
