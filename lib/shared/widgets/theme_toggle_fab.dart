import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/themes/theme_provider.dart';
import '../../core/themes/theme_tokens.dart';

class ThemeToggleFab extends ConsumerWidget {
  const ThemeToggleFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeId = ref.watch(themeProvider);
    final t = ref.watch(activeThemeTokensProvider);

    return FloatingActionButton(
      mini: true,
      backgroundColor: t.surface,
      foregroundColor: t.accent,
      elevation: 4,
      onPressed: () => ref.read(themeProvider.notifier).cycle(),
      tooltip: t.name,
      child: _themeIcon(themeId),
    );
  }

  Widget _themeIcon(AppThemeId id) => switch (id) {
    AppThemeId.pub => const Icon(Icons.local_bar, size: 18),
    AppThemeId.bull => const Icon(Icons.gps_fixed, size: 18),
    AppThemeId.classic => const Icon(Icons.sports_bar, size: 18),
    AppThemeId.min => const Icon(Icons.radio_button_unchecked, size: 18),
  };
}
