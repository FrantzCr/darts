import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_tokens.dart';

class ThemeNotifier extends Notifier<AppThemeId> {
  static const _key = 'active_theme';

  @override
  AppThemeId build() => AppThemeId.pub;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      state = AppThemeId.values.firstWhere((e) => e.name == raw, orElse: () => AppThemeId.pub);
    }
  }

  Future<void> setTheme(AppThemeId id) async {
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, id.name);
  }

  void cycle() {
    final ids = AppThemeId.values;
    final next = ids[(ids.indexOf(state) + 1) % ids.length];
    setTheme(next);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeId>(ThemeNotifier.new);

final activeThemeTokensProvider = Provider<AppThemeTokens>((ref) {
  final id = ref.watch(themeProvider);
  return themeById(id);
});
