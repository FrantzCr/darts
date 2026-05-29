import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/game_session.dart';
import '../../../core/models/player.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/history/providers/history_provider.dart';
import '../../../features/profile/providers/player_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_avatar.dart';
import '../../../shared/widgets/pub_card.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final players = ref.watch(playerProvider);
    final l10n = AppLocalizations.of(context);

    if (players.isEmpty) {
      return PubScreen(
        theme: t,
        floatingActionButton: const ThemeToggleFab(),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(t: t),
              Expanded(child: Center(child: Text(l10n.noPlayers, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5))))),
            ],
          ),
        ),
      );
    }

    _selectedPlayerId ??= players.first.id;
    final player = players.firstWhere((p) => p.id == _selectedPlayerId, orElse: () => players.first);

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(t: t),
            const SizedBox(height: 8),
            _PlayerSelector(players: players, selected: player, t: t, onSelect: (p) => setState(() => _selectedPlayerId = p.id)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _HeroCard(player: player, t: t),
                    const SizedBox(height: 16),
                    _PpdChart(player: player, t: t),
                    const SizedBox(height: 16),
                    _StatGrid(player: player, t: t),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final AppThemeTokens t;
  const _TopBar({required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: Icon(Icons.arrow_back_ios, color: t.textOnDark, size: 20),
          ),
          const SizedBox(width: 12),
          Text(l10n.stats, style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: t.displayFont)),
        ],
      ),
    );
  }
}

class _PlayerSelector extends StatelessWidget {
  final List<Player> players;
  final Player selected;
  final AppThemeTokens t;
  final ValueChanged<Player> onSelect;
  const _PlayerSelector({required this.players, required this.selected, required this.t, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: players.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final p = players[i];
          final isSelected = p.id == selected.id;
          return GestureDetector(
            onTap: () => onSelect(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? t.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: isSelected ? t.accent : t.surfaceBorder),
              ),
              child: Row(
                children: [
                  PubAvatar(initials: p.initials, color: p.color, theme: t, size: 24),
                  const SizedBox(width: 8),
                  Text(p.name, style: TextStyle(color: isSelected ? t.textOnDark : t.textOnDark.withValues(alpha: 0.7), fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Player player;
  final AppThemeTokens t;
  const _HeroCard({required this.player, required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PubCard(
      theme: t,
      child: Row(
        children: [
          PubAvatar(initials: player.initials, color: player.color, theme: t, size: 60, goldRing: player.currentStreak >= 3),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(player.name, style: TextStyle(color: t.text, fontSize: 20, fontWeight: FontWeight.w800, fontFamily: t.displayFont)),
              const SizedBox(height: 4),
              Text(
                '${(player.winRate * 100).round()}% ${l10n.totalWins.toLowerCase()} · ${player.totalGames} ${l10n.totalGames.toLowerCase()}',
                style: TextStyle(color: t.textDim, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final Player player;
  final AppThemeTokens t;
  const _StatGrid({required this.player, required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = [
      (l10n.ppd,           player.ppd.toStringAsFixed(1),                    l10n.ppdTooltip),
      (l10n.bestTurn,      '${player.bestTurn}',                              l10n.bestTurnTooltip),
      (l10n.doubleRate,    '${(player.doubleRate * 100).round()}%',           l10n.doubleRateTooltip),
      (l10n.totalWins,     '${player.totalWins}',                             l10n.totalWinsTooltip),
      (l10n.totalGames,    '${player.totalGames}',                            l10n.totalGamesTooltip),
      (l10n.scores100plus, '${player.scores100plus}',                         l10n.scores100plusTooltip),
      (l10n.tons180,       '${player.tons180}',                               l10n.tons180Tooltip),
      (l10n.currentStreak, '${player.currentStreak}',                         l10n.currentStreakTooltip),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: stats.map((s) => _StatTile(label: s.$1, value: s.$2, tooltip: s.$3, t: t)).toList(),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String tooltip;
  final AppThemeTokens t;
  const _StatTile({required this.label, required this.value, required this.tooltip, required this.t});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: PubCard(
        theme: t,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(label, style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 0.5)),
                const SizedBox(width: 4),
                Icon(Icons.help_outline, size: 11, color: t.textDim.withValues(alpha: 0.5)),
              ],
            ),
            Text(value, style: TextStyle(color: t.text, fontSize: 24, fontWeight: FontWeight.w800, fontFamily: t.monoFont)),
          ],
        ),
      ),
    );
  }
}

// PPD trend over last 10 games
class _PpdChart extends ConsumerWidget {
  final Player player;
  final AppThemeTokens t;
  const _PpdChart({required this.player, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(historyProvider);
    final playerSessions = sessions
        .where((s) => s.playerIds.contains(player.id))
        .take(10)
        .toList()
        .reversed
        .toList();

    if (playerSessions.length < 2) return const SizedBox.shrink();

    final spots = playerSessions.asMap().entries.map((e) {
      final ppd = _sessionPpd(e.value, player.id);
      return FlSpot(e.key.toDouble(), ppd);
    }).toList();

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final padding = ((maxY - minY) * 0.2).clamp(2.0, double.infinity);

    return PubCard(
      theme: t,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PPD', style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                minY: (minY - padding).clamp(0.0, double.infinity),
                maxY: maxY + padding,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: ((maxY - minY + padding * 2) / 3).clamp(1.0, double.infinity),
                  getDrawingHorizontalLine: (_) => FlLine(color: t.surfaceBorder.withValues(alpha: 0.3), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0), style: TextStyle(color: t.textDim, fontSize: 9)),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: t.accent,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 3,
                        color: t.accent,
                        strokeWidth: 1.5,
                        strokeColor: t.surface,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: t.accent.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _sessionPpd(GameSession session, String playerId) {
    final turns = session.turns.where((t) => t.playerId == playerId && !t.bust).toList();
    final darts = session.turns.where((t) => t.playerId == playerId).fold<int>(0, (s, t) => s + t.dartLabels.length);
    final points = turns.fold<int>(0, (s, t) => s + t.total);
    return darts == 0 ? 0.0 : points / darts;
  }
}
