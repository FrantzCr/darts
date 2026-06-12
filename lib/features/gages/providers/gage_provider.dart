import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/gage.dart';

// ── Default gage list ────────────────────────────────────────────────────────

const _kDefaultGages = [
  Gage(id: 'def-01', text: 'Boire une gorgée', isAdult: false),
  Gage(id: 'def-02', text: 'Faire 10 pompes', isAdult: false),
  Gage(id: 'def-03', text: 'Chanter 10 secondes', isAdult: false),
  Gage(id: 'def-04', text: 'Raconter une blague', isAdult: false),
  Gage(id: 'def-05', text: 'Imiter un animal', isAdult: false),
  Gage(id: 'def-06', text: 'Sauter à cloche-pied 30 secondes', isAdult: false),
  Gage(id: 'def-07', text: 'Dire un compliment à chaque joueur', isAdult: false),
  Gage(id: 'def-08', text: 'Parler avec un accent jusqu\'au prochain tour', isAdult: false),
  Gage(id: 'def-09', text: 'Faire une danse de 15 secondes', isAdult: false),
  Gage(id: 'def-10', text: 'Échanger de place avec quelqu\'un', isAdult: false),
  Gage(id: 'adu-01', text: 'Shot !', isAdult: true),
  Gage(id: 'adu-02', text: 'Boire cul sec', isAdult: true),
  Gage(id: 'adu-03', text: 'Deux gorgées au joueur de votre choix', isAdult: true),
  Gage(id: 'adu-04', text: 'Vider son verre', isAdult: true),
  Gage(id: 'adu-05', text: 'Raconter une histoire embarrassante', isAdult: true),
  Gage(id: 'adu-06', text: 'Révéler un secret', isAdult: true),
  Gage(id: 'adu-07', text: 'La tournée pour tout le monde', isAdult: true),
  Gage(id: 'adu-08', text: 'Appeler quelqu\'un en direct', isAdult: true),
  Gage(id: 'adu-09', text: 'Vérité ou défi au choix des autres', isAdult: true),
  Gage(id: 'adu-10', text: 'Challenge imposé par le vainqueur', isAdult: true),
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

  /// Gages active for the current mode (used by the wheel).
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
  static const _kGagesKey = 'gage_list_v1';
  static const _kEnabledKey = 'wheel_enabled';
  static const _kAdultKey = 'wheel_adult_mode';

  @override
  GageSettings build() {
    _load();
    return const GageSettings(gages: _kDefaultGages);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_kGagesKey);
    final enabled = prefs.getBool(_kEnabledKey) ?? false;
    final adultMode = prefs.getBool(_kAdultKey) ?? false;

    final gages = jsonList == null ? _kDefaultGages : Gage.listFromJsonList(jsonList);
    state = GageSettings(gages: gages, enabled: enabled, adultMode: adultMode);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kGagesKey, Gage.listToJsonList(state.gages));
    await prefs.setBool(_kEnabledKey, state.enabled);
    await prefs.setBool(_kAdultKey, state.adultMode);
  }

  Future<void> addGage(String text, bool isAdult) async {
    final gage = Gage(id: const Uuid().v4(), text: text.trim(), isAdult: isAdult);
    state = state.copyWith(gages: [...state.gages, gage]);
    await _persist();
  }

  Future<void> updateGage(Gage updated) async {
    state = state.copyWith(
      gages: state.gages.map((g) => g.id == updated.id ? updated : g).toList(),
    );
    await _persist();
  }

  Future<void> removeGage(String id) async {
    state = state.copyWith(gages: state.gages.where((g) => g.id != id).toList());
    await _persist();
  }

  Future<void> setEnabled(bool value) async {
    state = state.copyWith(enabled: value);
    await _persist();
  }

  Future<void> setAdultMode(bool value) async {
    state = state.copyWith(adultMode: value);
    await _persist();
  }
}

final gageProvider = NotifierProvider<GageNotifier, GageSettings>(GageNotifier.new);
