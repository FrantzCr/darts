import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_session.dart';
import '../models/player.dart';

class FirestoreUserService {
  static final _db = FirebaseFirestore.instance;

  static String _playersPath(String uid) => 'users/$uid/players';
  static String _historyPath(String uid) => 'users/$uid/history';

  // ── Players ──────────────────────────────────────────────────────────

  static Future<List<Player>> loadPlayers(String uid) async {
    final snap = await _db.collection(_playersPath(uid)).get();
    return snap.docs.map((d) => Player.fromFirestore(d.id, d.data())).toList();
  }

  static Future<void> savePlayer(String uid, Player player) async {
    await _db
        .collection(_playersPath(uid))
        .doc(player.id)
        .set(player.toFirestore());
  }

  static Future<void> deletePlayer(String uid, String playerId) async {
    await _db.collection(_playersPath(uid)).doc(playerId).delete();
  }

  // ── History ──────────────────────────────────────────────────────────

  static Future<List<GameSession>> loadHistory(String uid) async {
    final snap = await _db
        .collection(_historyPath(uid))
        .orderBy('playedAt', descending: true)
        .get();
    return snap.docs
        .map((d) => GameSession.fromFirestore(d.id, d.data()))
        .toList();
  }

  static Future<void> saveGameSession(String uid, GameSession session) async {
    await _db
        .collection(_historyPath(uid))
        .doc(session.id)
        .set(session.toFirestore());
  }
}
