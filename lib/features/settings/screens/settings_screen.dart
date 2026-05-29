import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_card.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../providers/locale_provider.dart';

const _locales = [
  ('fr', 'Français', '🇫🇷'),
  ('en', 'English', '🇬🇧'),
  ('es', 'Español', '🇪🇸'),
  ('da', 'Dansk', '🇩🇰'),
  ('ru', 'Русский', '🇷🇺'),
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(themeProvider);

    return PubScreen(
      theme: t,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  PubBackButton(t: t, onTap: () => context.go('/')),
                  const SizedBox(width: 12),
                  Text(
                    l10n.settings,
                    style: TextStyle(
                      color: t.textOnDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: t.displayFont,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  _SectionLabel(label: 'Langue', t: t),
                  const SizedBox(height: 8),
                  PubCard(
                    theme: t,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (int i = 0; i < _locales.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: t.surfaceBorder.withValues(alpha: 0.5)),
                          _LocaleRow(
                            code: _locales[i].$1,
                            label: _locales[i].$2,
                            flag: _locales[i].$3,
                            selected: currentLocale.languageCode == _locales[i].$1,
                            t: t,
                            onTap: () => ref.read(localeProvider.notifier).setLocale(Locale(_locales[i].$1)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel(label: 'Apparence', t: t),
                  const SizedBox(height: 8),
                  PubCard(
                    theme: t,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (int i = 0; i < AppThemeId.values.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: t.surfaceBorder.withValues(alpha: 0.5)),
                          _ThemeRow(
                            id: AppThemeId.values[i],
                            selected: currentTheme == AppThemeId.values[i],
                            t: t,
                            onTap: () => ref.read(themeProvider.notifier).setTheme(AppThemeId.values[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppThemeTokens t;
  const _SectionLabel({required this.label, required this.t});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: t.textOnDark.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _LocaleRow extends StatelessWidget {
  final String code;
  final String label;
  final String flag;
  final bool selected;
  final AppThemeTokens t;
  final VoidCallback onTap;
  const _LocaleRow({
    required this.code,
    required this.label,
    required this.flag,
    required this.selected,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? t.accent : t.text,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: t.accent, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final AppThemeId id;
  final bool selected;
  final AppThemeTokens t;
  final VoidCallback onTap;
  const _ThemeRow({
    required this.id,
    required this.selected,
    required this.t,
    required this.onTap,
  });

  String _localizedName(AppLocalizations l10n) => switch (id) {
    AppThemeId.pub     => l10n.themePub,
    AppThemeId.bull    => l10n.themeBull,
    AppThemeId.classic => l10n.themeClassic,
    AppThemeId.min     => l10n.themeMin,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = themeById(id);
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: tokens.bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: tokens.accent, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: tokens.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedName(l10n),
                    style: TextStyle(
                      color: selected ? t.accent : t.text,
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  Text(
                    tokens.tag,
                    style: TextStyle(color: t.textDim, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: t.accent, size: 20),
          ],
        ),
      ),
    );
  }
}
