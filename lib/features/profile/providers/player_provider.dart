import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/player.dart';
import '../../../core/services/firestore_user_service.dart';
import '../../auth/providers/auth_provider.dart';

const _boxName = 'players';

class PlayerNotifier extends Notifier<List<Player>> {
  @override
  List<Player> build() {
    // When auth state changes (sign-in), sync from Firestore
    ref.listen(authUserProvider, (prev, next) {
      next.whenData((user) {
        if (user != null) _syncFromCloud(user.uid);
      });
    });

    // If already signed in at build time, sync immediately
    final user = ref.read(authUserProvider).value;
    if (user != null) {
      Future.microtask(() => _syncFromCloud(user.uid));
    }

    final box = Hive.box<Player>(_boxName);
    return box.values.toList();
  }

  Future<void> _syncFromCloud(String uid) async {
    try {
      final cloud = await FirestoreUserService.loadPlayers(uid);
      final box = Hive.box<Player>(_boxName);

      if (cloud.isEmpty) {
        // First sign-in on this account: push local players to cloud
        for (final p in box.values) {
          await FirestoreUserService.savePlayer(uid, p);
        }
      } else {
        // Cloud is source of truth: overwrite local
        await box.clear();
        for (final p in cloud) {
          await box.put(p.id, p);
        }
        state = box.values.toList();
      }
    } catch (e, st) {
      debugPrint('[Player] _syncFromCloud error: $e\n$st');
    }
  }

  Future<Player> createPlayer({
    required String name,
    required String colorHex,
    String hand = 'right',
  }) async {
    final player = Player(
      id: const Uuid().v4(),
      name: name,
      colorHex: colorHex,
      hand: hand,
    );
    final box = Hive.box<Player>(_boxName);
    await box.put(player.id, player);
    state = box.values.toList();
    _pushToCloud(player);
    return player;
  }

  Future<void> updatePlayer(Player player) async {
    final box = Hive.box<Player>(_boxName);
    await box.put(player.id, player);
    state = box.values.toList();
    _pushToCloud(player);
  }

  Future<void> deletePlayer(String id) async {
    final box = Hive.box<Player>(_boxName);
    await box.delete(id);
    state = box.values.toList();
    _deleteFromCloud(id);
  }

  Player? findById(String id) {
    return state.where((p) => p.id == id).firstOrNull;
  }

  void _pushToCloud(Player player) {
    final user = ref.read(authUserProvider).value;
    if (user != null) {
      FirestoreUserService.savePlayer(user.uid, player).catchError((e, st) {
        debugPrint('[Player] _pushToCloud error: $e\n$st');
      });
    }
  }

  void _deleteFromCloud(String playerId) {
    final user = ref.read(authUserProvider).value;
    if (user != null) {
      FirestoreUserService.deletePlayer(user.uid, playerId)
          .catchError((e, st) {
        debugPrint('[Player] _deleteFromCloud error: $e\n$st');
      });
    }
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, List<Player>>(PlayerNotifier.new);
