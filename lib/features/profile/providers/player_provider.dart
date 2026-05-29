import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/player.dart';

const _boxName = 'players';

class PlayerNotifier extends Notifier<List<Player>> {
  @override
  List<Player> build() {
    final box = Hive.box<Player>(_boxName);
    return box.values.toList();
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
    return player;
  }

  Future<void> updatePlayer(Player player) async {
    final box = Hive.box<Player>(_boxName);
    await box.put(player.id, player);
    state = box.values.toList();
  }

  Future<void> deletePlayer(String id) async {
    final box = Hive.box<Player>(_boxName);
    await box.delete(id);
    state = box.values.toList();
  }

  Player? findById(String id) {
    return state.where((p) => p.id == id).firstOrNull;
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, List<Player>>(PlayerNotifier.new);
