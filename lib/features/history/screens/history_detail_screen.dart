import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../features/history/providers/history_provider.dart';
import '../../../features/profile/providers/player_provider.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final String sessionId;
  const HistoryDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);
    final session = ref.read(historyProvider.notifier).findById(sessionId);
    final players = ref.watch(playerProvider);

    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/history'));
      return const SizedBox.shrink();
    }

    final sessionPlayers = session.playerIds
        .map((id) => players.where((p) => p.id == id).firstOrNull)
        .toList();

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/history'),
                    child: Icon(Icons.arrow_back_ios, color: t.textOnDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Détail de la partie', style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: t.displayFont)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionPlayers.map((p) => p?.name ?? '?').join(' vs '),
                    style: TextStyle(color: t.textOnDark, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${session.rounds} manches · ${session.playerIds.length} joueurs',
                    style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
            if (session.winnerId != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: t.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(t.shape.smRadius),
                    border: Border.all(color: t.gold),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, color: t.gold, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Vainqueur : ${sessionPlayers.firstWhere((p) => p?.id == session.winnerId, orElse: () => null)?.name ?? "?"}',
                        style: TextStyle(color: t.gold, fontWeight: FontWeight.w600),
                      ),
                      if (session.winnerLastDart != null) ...[
                        Text(' · finit sur ', style: TextStyle(color: t.gold.withValues(alpha: 0.7))),
                        Text(session.winnerLastDart!, style: TextStyle(color: t.gold, fontWeight: FontWeight.w700, fontFamily: t.monoFont)),
                      ],
                    ],
                  ),
                ),
              ),
            Expanded(
              child: session.turns.isEmpty
                  ? Center(child: Text('Détails par tour non disponibles', style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5))))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: session.turns.length,
                      itemBuilder: (_, i) {
                        final turn = session.turns[i];
                        final player = sessionPlayers.firstWhere((p) => p?.id == turn.playerId, orElse: () => null);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: t.surface.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(t.shape.smRadius),
                          ),
                          child: Row(
                            children: [
                              Text('M${turn.roundNumber}', style: TextStyle(color: t.textDim, fontSize: 11, fontFamily: t.monoFont, letterSpacing: 1)),
                              const SizedBox(width: 12),
                              Text(player?.name ?? '?', style: TextStyle(color: t.textOnDark, fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Text(turn.dartLabels.join(' · '), style: TextStyle(color: t.accent, fontSize: 13, fontFamily: t.monoFont)),
                              const Spacer(),
                              Text('+${turn.total}', style: TextStyle(color: t.gold, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: t.monoFont)),
                              const SizedBox(width: 8),
                              Text('→ ${turn.remaining}', style: TextStyle(color: t.textDim, fontSize: 12, fontFamily: t.monoFont)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
