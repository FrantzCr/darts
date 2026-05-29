import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/profile/providers/player_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_avatar.dart';
import '../../../shared/widgets/pub_card.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);
    final players = ref.watch(playerProvider);

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _BrandBar(t: t),
                  const SizedBox(height: 28),
                  _HeroCTA(t: t),
                  const SizedBox(height: 24),
                  if (players.isNotEmpty) ...[
                    _LeaderboardCard(t: t, players: players),
                    const SizedBox(height: 24),
                  ],
                  _ShortcutsRow(t: t),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  final AppThemeTokens t;
  const _BrandBar({required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.homeTitle,
          style: TextStyle(
            color: t.textOnDark,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            fontFamily: t.displayFont,
            height: 1.0,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.go('/settings'),
          child: Icon(Icons.settings_outlined, color: t.textOnDark.withValues(alpha: 0.65), size: 24),
        ),
      ],
    );
  }
}

class _HeroCTA extends ConsumerWidget {
  final AppThemeTokens t;
  const _HeroCTA({required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.go('/new-game'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [t.accent, t.accent.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(t.shape.cardRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.newGame,
                    style: TextStyle(
                      color: t.textOnDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: t.displayFont,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.gameDesc301,
                    style: TextStyle(
                      color: t.textOnDark.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: t.textOnDark, size: 22),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final AppThemeTokens t;
  final List<dynamic> players;
  const _LeaderboardCard({required this.t, required this.players});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sorted = [...players]..sort((a, b) => b.winRate.compareTo(a.winRate));
    final top = sorted.take(5).toList();

    return PubCard(
      theme: t,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.seasonLeaderboard,
            style: TextStyle(
              color: t.textDim,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...top.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: i == 0 ? t.gold : t.textDim,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  PubAvatar(initials: p.initials, color: p.color, theme: t, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p.name,
                      style: TextStyle(color: t.text, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${(p.winRate * 100).round()}%',
                    style: TextStyle(
                      color: t.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: t.monoFont,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ShortcutsRow extends StatelessWidget {
  final AppThemeTokens t;
  const _ShortcutsRow({required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _Shortcut(icon: Icons.history, label: l10n.history, route: '/history', t: t),
        const SizedBox(width: 12),
        _Shortcut(icon: Icons.bar_chart, label: l10n.stats, route: '/stats', t: t),
        const SizedBox(width: 12),
        _Shortcut(icon: Icons.person, label: l10n.players, route: '/profile', t: t),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final AppThemeTokens t;
  const _Shortcut({required this.icon, required this.label, required this.route, required this.t});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: t.surface.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(t.shape.cardRadius),
            border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Icon(icon, color: t.textOnDark, size: 22),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(color: t.textOnDark, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
