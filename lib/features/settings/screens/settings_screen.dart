import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/auth/providers/auth_provider.dart';
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
    final authUser = ref.watch(authUserProvider);

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
                  _SectionLabel(label: 'Compte', t: t),
                  const SizedBox(height: 8),
                  PubCard(
                    theme: t,
                    padding: EdgeInsets.zero,
                    child: authUser.when(
                      data: (user) => user == null
                          ? _SignInRow(t: t, onTap: () => context.go('/welcome'))
                          : _AccountRow(user: user, t: t),
                      loading: () => const SizedBox(height: 56),
                      error: (_, __) => _SignInRow(t: t, onTap: () => context.go('/welcome')),
                    ),
                  ),
                  const SizedBox(height: 28),
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

class _SignInRow extends StatelessWidget {
  final AppThemeTokens t;
  final VoidCallback onTap;
  const _SignInRow({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.login_rounded, color: t.accent, size: 22),
            const SizedBox(width: 14),
            Text(
              'Se connecter avec Google',
              style: TextStyle(color: t.accent, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: t.textDim, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends ConsumerWidget {
  final User user;
  final AppThemeTokens t;
  const _AccountRow({required this.user, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                backgroundColor: t.accent.withValues(alpha: 0.2),
                child: user.photoURL == null
                    ? Text(
                        (user.displayName ?? user.email ?? '?')[0].toUpperCase(),
                        style: TextStyle(color: t.accent, fontWeight: FontWeight.w700, fontSize: 14),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'Utilisateur',
                      style: TextStyle(color: t.text, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      user.email ?? '',
                      style: TextStyle(color: t.textDim, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: t.surfaceBorder.withValues(alpha: 0.5)),
        GestureDetector(
          onTap: () async {
            await signOut();
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.logout_rounded, color: Colors.red.withValues(alpha: 0.8), size: 20),
                const SizedBox(width: 14),
                Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red.withValues(alpha: 0.8), fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
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
