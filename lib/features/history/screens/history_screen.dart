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
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _selectedPlayerId; // null = tous les joueurs

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final sessions = ref.watch(historyProvider);
    final players = ref.watch(playerProvider);
    final l10n = AppLocalizations.of(context);

    final filtered = _selectedPlayerId == null
        ? sessions
        : sessions.where((s) => s.playerIds.contains(_selectedPlayerId)).toList();

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(t: t),
            if (players.isNotEmpty)
              _PlayerFilter(
                players: players,
                selectedId: _selectedPlayerId,
                t: t,
                onSelect: (id) => setState(() => _selectedPlayerId = id),
              ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(l10n.noGames, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5))))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _GameRow(
                        session: filtered[i],
                        t: t,
                        players: players,
                        onTap: () => context.go('/history/${filtered[i].id}'),
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
          PubBackButton(t: t, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Text(l10n.history, style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: t.displayFont)),
        ],
      ),
    );
  }
}

class _PlayerFilter extends StatelessWidget {
  final List<Player> players;
  final String? selectedId;
  final AppThemeTokens t;
  final ValueChanged<String?> onSelect;
  const _PlayerFilter({required this.players, required this.selectedId, required this.t, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Center(
            child: _FilterChip(
              label: l10n.all,
              isSelected: selectedId == null,
              t: t,
              onTap: () => onSelect(null),
            ),
          ),
          const SizedBox(width: 8),
          ...players.map((p) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: _FilterChip(
                label: p.name,
                isSelected: selectedId == p.id,
                t: t,
                onTap: () => onSelect(p.id),
                avatar: PubAvatar(initials: p.initials, color: p.color, theme: t, size: 24),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final AppThemeTokens t;
  final VoidCallback onTap;
  final Widget? avatar;
  const _FilterChip({required this.label, required this.isSelected, required this.t, required this.onTap, this.avatar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: avatar != null ? 12 : 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? t.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isSelected ? t.accent : t.surfaceBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[avatar!, const SizedBox(width: 6)],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? t.textOnDark : t.textOnDark.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  final GameSession session;
  final AppThemeTokens t;
  final List<Player> players;
  final VoidCallback onTap;
  const _GameRow({required this.session, required this.t, required this.players, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessionPlayers = session.playerIds
        .map((id) => players.where((p) => p.id == id).firstOrNull)
        .where((p) => p != null)
        .toList();

    final date = _formatDate(session.playedAt, l10n);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(t.shape.cardRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 36,
              child: Stack(
                children: sessionPlayers.take(3).toList().asMap().entries.map((e) => Positioned(
                  left: e.key * 14.0,
                  child: PubAvatar(
                    initials: e.value!.initials,
                    color: e.value!.color,
                    theme: t,
                    size: 30,
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sessionPlayers.map((p) => p!.name).join(' ${l10n.vs} '),
                          style: TextStyle(color: t.textOnDark, fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: t.surface.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          _modeLabel(session.startScore),
                          style: TextStyle(color: t.textOnDark.withValues(alpha: 0.75), fontSize: 10, fontWeight: FontWeight.w700, fontFamily: t.monoFont),
                        ),
                      ),
                    ],
                  ),
                  Text(date, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5), fontSize: 11)),
                ],
              ),
            ),
            if (session.winnerId != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: t.gold, borderRadius: BorderRadius.circular(4)),
                child: Text(l10n.winBadge, style: TextStyle(color: t.onGold, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: t.textOnDark.withValues(alpha: 0.4), size: 18),
          ],
        ),
      ),
    );
  }

  String _modeLabel(int startScore) => switch (startScore) {
    0   => 'Clock',
    501 => '501',
    _   => '301',
  };

  String _formatDate(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return l10n.today;
    if (diff.inDays == 1) return l10n.yesterday;
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
