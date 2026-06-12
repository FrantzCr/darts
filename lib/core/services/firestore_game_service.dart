import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/active_game_state.dart';

class FirestoreGameService {
  static final _db = FirebaseFirestore.instance;
  static const _activeCol = 'active_games';
  static const _gamesCol = 'games';

  static Future<({String gameId, String code})> createActiveGame({
    required String hostUid,
    required String hostName,
    required ActiveGameState game,
  }) async {
    final code = _generateCode();
    final doc = _db.collection(_activeCol).doc();
    await doc.set({
      'code': code,
      'hostUid': hostUid,
      'hostName': hostName,
      'gameMode': game.gameMode.name,
      'startScore': game.startScore,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'players': game.players.map((p) => {
        'id': p.player.id.toString(),
        'name': p.player.name,
        'color': p.player.color,
      }).toList(),
      'state': _buildState(game),
    });
    return (gameId: doc.id, code: code);
  }

  static Future<void> updateState(String gameId, ActiveGameState game) async {
    try {
      await _db.collection(_activeCol).doc(gameId).update({
        'state': _buildState(game),
      });
    } catch (_) {}
  }

  static Future<void> finalizeGame(String gameId, ActiveGameState game) async {
    try {
      final batch = _db.batch();
      batch.set(_db.collection(_gamesCol).doc(gameId), {
        'gameMode': game.gameMode.name,
        'startScore': game.startScore,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'durationSeconds': DateTime.now().difference(game.startedAt).inSeconds,
        'players': game.players.map((p) => {
          'id': p.player.id.toString(),
          'name': p.player.name,
          'score': p.score,
          'isWinner': game.isRtc ? p.score > 20 : p.score == 0,
        }).toList(),
      });
      batch.delete(_db.collection(_activeCol).doc(gameId));
      await batch.commit();
    } catch (_) {}
  }

  static Stream<List<Map<String, dynamic>>> watchActiveGames() {
    return _db
        .collection(_activeCol)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  static Stream<Map<String, dynamic>?> watchGame(String gameId) {
    return _db
        .collection(_activeCol)
        .doc(gameId)
        .snapshots()
        .map((d) => d.exists ? {'id': d.id, ...d.data()!} : null);
  }

  static Future<String?> findGameByCode(String code) async {
    final q = await _db
        .collection(_activeCol)
        .where('code', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    if (q.docs.isEmpty) return null;
    return q.docs.first.id;
  }

  static Map<String, dynamic> _buildState(ActiveGameState s) {
    return {
      'round': s.round,
      'activeIndex': s.activeIndex,
      'activePlayerName': s.me.player.name,
      'scores': {for (final p in s.players) p.player.id.toString(): p.score},
      'currentTurnDarts': s.turn
          .map((d) => {'label': d.label, 'value': d.value, 'rtcHit': d.rtcHit})
          .toList(),
      'status': s.status.name,
      'winnerName': s.status == GameStatus.win ? s.me.player.name : null,
    };
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
