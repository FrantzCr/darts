import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/gage.dart';

// ── Default gage list ────────────────────────────────────────────────────────

const _kDefaultGages = [
  // Famille
  Gage(id: 'def-01', text: 'Boire une gorgée', isAdult: false, emoji: '🍺'),
  Gage(id: 'def-02', text: 'Faire 10 pompes', isAdult: false, emoji: '💪'),
  Gage(id: 'def-03', text: 'Chanter 10 secondes', isAdult: false, emoji: '🎤'),
  Gage(id: 'def-04', text: 'Raconter une blague', isAdult: false, emoji: '😂'),
  Gage(id: 'def-05', text: 'Imiter un animal', isAdult: false, emoji: '🐾'),
  Gage(id: 'def-06', text: 'Sauter à cloche-pied 30 secondes', isAdult: false, emoji: '🦵'),
  Gage(id: 'def-07', text: 'Dire un compliment à chaque joueur', isAdult: false, emoji: '❤️'),
  Gage(id: 'def-08', text: 'Parler avec un accent jusqu\'au prochain tour', isAdult: false, emoji: '🗣️'),
  Gage(id: 'def-09', text: 'Faire une danse de 15 secondes', isAdult: false, emoji: '💃'),
  Gage(id: 'def-10', text: 'Échanger de place avec quelqu\'un', isAdult: false, emoji: '🔄'),
  Gage(id: 'def-11', text: 'Mimer un film sans parler', isAdult: false, emoji: '🎬'),
  Gage(id: 'def-12', text: 'Faire 20 squats', isAdult: false, emoji: '🏋️'),
  Gage(id: 'def-13', text: 'Dire 5 mots dans une autre langue', isAdult: false, emoji: '🌍'),
  Gage(id: 'def-14', text: 'Raconter ta plus grande gaffe', isAdult: false, emoji: '😬'),
  Gage(id: 'def-15', text: 'Faire une grimace pendant 30 secondes', isAdult: false, emoji: '🤪'),
  Gage(id: 'def-16', text: 'Choisir un défi pour un autre joueur', isAdult: false, emoji: '👉'),
  Gage(id: 'def-17', text: 'Faire le tour de la pièce en sautillant', isAdult: false, emoji: '🐸'),
  Gage(id: 'def-18', text: 'Deviner une chanson en 5 notes sifflées', isAdult: false, emoji: '🎵'),
  Gage(id: 'def-19', text: 'Faire 15 secondes de planche', isAdult: false, emoji: '🧘'),
  Gage(id: 'def-20', text: 'Prendre une photo de groupe maintenant', isAdult: false, emoji: '📸'),
  // Adulte
  Gage(id: 'adu-01', text: 'Shot !', isAdult: true, emoji: '🥃'),
  Gage(id: 'adu-02', text: 'Boire cul sec', isAdult: true, emoji: '🍹'),
  Gage(id: 'adu-03', text: 'Deux gorgées au joueur de votre choix', isAdult: true, emoji: '🎯'),
  Gage(id: 'adu-04', text: 'Vider son verre', isAdult: true, emoji: '🍾'),
  Gage(id: 'adu-05', text: 'Raconter une histoire embarrassante', isAdult: true, emoji: '😳'),
  Gage(id: 'adu-06', text: 'Révéler un secret', isAdult: true, emoji: '🤫'),
  Gage(id: 'adu-07', text: 'La tournée pour tout le monde', isAdult: true, emoji: '🎉'),
  Gage(id: 'adu-08', text: 'Appeler quelqu\'un en direct', isAdult: true, emoji: '📱'),
  Gage(id: 'adu-09', text: 'Vérité ou défi au choix des autres', isAdult: true, emoji: '❓'),
  Gage(id: 'adu-10', text: 'Challenge imposé par le vainqueur', isAdult: true, emoji: '🏆'),
  Gage(id: 'adu-11', text: 'Inventer une règle pour ce tour', isAdult: true, emoji: '📜'),
  Gage(id: 'adu-12', text: 'Choisir qui boit avec toi', isAdult: true, emoji: '🫃'),
  Gage(id: 'adu-13', text: 'Raconter ton pire rencard', isAdult: true, emoji: '💔'),
  Gage(id: 'adu-14', text: 'Boire avec la main gauche jusqu\'au prochain tour', isAdult: true, emoji: '🤚'),
  Gage(id: 'adu-15', text: 'Imiter un joueur, les autres devinent qui', isAdult: true, emoji: '🎭'),
  Gage(id: 'adu-16', text: 'Interdiction de dire "je" jusqu\'au prochain tour', isAdult: true, emoji: '🚫'),
  Gage(id: 'adu-17', text: 'Faire une déclaration sincère', isAdult: true, emoji: '💬'),
  Gage(id: 'adu-18', text: 'Minuit — tout le monde boit !', isAdult: true, emoji: '🌙'),
  Gage(id: 'adu-19', text: 'Montrer le dernier message envoyé', isAdult: true, emoji: '💌'),
  Gage(id: 'adu-20', text: 'Duel de bras de fer avec le joueur suivant', isAdult: true, emoji: '🤜'),
];

// ── Settings model ───────────────────────────────────────────────────────────

class GageSettings {
  final List<Gage> gages;
  final bool enabled;
  final bool adultMode;

  const GageSettings({
    required this.gages,
    this.enabled = false,
    this.adultMode = false,
  });

  List<Gage> get activeGages =>
      adultMode ? gages.where((g) => g.isAdult).toList() : gages.where((g) => !g.isAdult).toList();

  GageSettings copyWith({List<Gage>? gages, bool? enabled, bool? adultMode}) => GageSettings(
    gages: gages ?? this.gages,
    enabled: enabled ?? this.enabled,
    adultMode: adultMode ?? this.adultMode,
  );
}

// ── Notifier ────────────────────────────────────────────────────────────────

class GageNotifier extends Notifier<GageSettings> {
  static const _kEnabledKey = 'wheel_enabled';
  static const _kAdultKey = 'wheel_adult_mode';
  static final _doc =
      FirebaseFirestore.instance.collection('gages').doc('list');

  bool _enabled = false;
  bool _adultMode = false;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

  @override
  GageSettings build() {
    ref.onDispose(() => _sub?.cancel());
    _init();
    return const GageSettings(gages: _kDefaultGages);
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_kEnabledKey) ?? false;
    _adultMode = prefs.getBool(_kAdultKey) ?? false;
    state = state.copyWith(enabled: _enabled, adultMode: _adultMode);

    _sub = _doc.snapshots().listen((snap) {
      List<Gage> gages;
      if (!snap.exists) {
        gages = _kDefaultGages;
        _writeGages(_kDefaultGages);
      } else {
        final raw = (snap.data()?['gages'] as List<dynamic>?) ?? [];
        if (raw.isEmpty) {
          gages = _kDefaultGages;
          _writeGages(_kDefaultGages);
        } else {
          gages = raw.map((e) => Gage.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      state = GageSettings(gages: gages, enabled: _enabled, adultMode: _adultMode);
    }, onError: (_) {
      // Firestore unavailable — keep current state
    });
  }

  Future<void> _writeGages(List<Gage> gages) async {
    try {
      await _doc.set({'gages': gages.map((g) => g.toJson()).toList()});
    } catch (_) {}
  }

  Future<void> _persistSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabledKey, _enabled);
    await prefs.setBool(_kAdultKey, _adultMode);
  }

  Future<void> addGage(String text, bool isAdult, {String emoji = '🎯'}) async {
    final gage = Gage(id: const Uuid().v4(), text: text.trim(), isAdult: isAdult, emoji: emoji);
    final newList = [...state.gages, gage];
    state = state.copyWith(gages: newList);
    await _writeGages(newList);
  }

  Future<void> updateGage(Gage updated) async {
    final newList = state.gages.map((g) => g.id == updated.id ? updated : g).toList();
    state = state.copyWith(gages: newList);
    await _writeGages(newList);
  }

  Future<void> removeGage(String id) async {
    final newList = state.gages.where((g) => g.id != id).toList();
    state = state.copyWith(gages: newList);
    await _writeGages(newList);
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    state = state.copyWith(enabled: value);
    await _persistSettings();
  }

  Future<void> setAdultMode(bool value) async {
    _adultMode = value;
    state = state.copyWith(adultMode: value);
    await _persistSettings();
  }
}

final gageProvider = NotifierProvider<GageNotifier, GageSettings>(GageNotifier.new);
