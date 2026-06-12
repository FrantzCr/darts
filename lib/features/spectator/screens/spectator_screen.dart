import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/firestore_game_service.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_card.dart';
import '../../../shared/widgets/pub_screen.dart';
class SpectatorScreen extends ConsumerWidget {
  final String gameId;
  const SpectatorScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);

    return StreamBuilder<Map<String, dynamic>?>(
      stream: FirestoreGameService.watchGame(gameId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PubScreen(theme: t, child: const Center(child: CircularProgressIndicator()));
        }

        final data = snapshot.data;
        if (data == null) {
          return PubScreen(
            theme: t,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🏆', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      'Partie terminée',
                      style: TextStyle(color: t.textOnDark, fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => context.go('/live'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: t.accent,
                          borderRadius: BorderRadius.circular(t.shape.buttonRadius),
                        ),
                        child: Text('Retour aux parties', style: TextStyle(color: t.textOnDark, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final state = data['state'] as Map<String, dynamic>? ?? {};
        final players = (data['players'] as List? ?? []).cast<Map<String, dynamic>>();
        final code = data['code'] as String? ?? '';
        final hostName = data['hostName'] as String? ?? '';
        final gameMode = data['gameMode'] as String? ?? 'classic';
        final round = state['round'] as int? ?? 1;
        final activeIndex = state['activeIndex'] as int? ?? 0;
        final scores = ((state['scores'] as Map?)?.cast<String, dynamic>() ?? {})
            .map((k, v) => MapEntry(k, (v as num).toInt()));
        final currentTurnDarts = (state['currentTurnDarts'] as List? ?? []).cast<Map<String, dynamic>>();
        final status = state['status'] as String? ?? 'playing';
        final winnerName = state['winnerName'] as String?;

        return PubScreen(
          theme: t,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      PubBackButton(t: t, onTap: () => context.go('/live')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Partie de $hostName',
                              style: TextStyle(color: t.textOnDark, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Manche $round · Code $code',
                              style: TextStyle(color: t.textDim, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      status == 'win' ? _WinBadge(t: t) : const _LiveBadge(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: players.asMap().entries.map((entry) {
                      final i = entry.key;
                      final p = entry.value;
                      final playerId = p['id'] as String;
                      final score = scores[playerId] ?? 0;
                      final isActive = i == activeIndex;
                      Color playerColor;
                      try {
                        playerColor = Color(int.parse((p['color'] as String).replaceFirst('#', '0xFF')));
                      } catch (_) {
                        playerColor = t.accent;
                      }
                      final displayScore = gameMode == 'rtc'
                          ? '${(score - 1).clamp(0, 20)}/20'
                          : '$score';

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: i > 0 ? 8 : 0),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isActive ? t.accent.withValues(alpha: 0.12) : t.surface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(t.shape.cardRadius),
                            border: Border.all(
                              color: isActive ? t.accent : t.surfaceBorder.withValues(alpha: 0.3),
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(color: playerColor, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      p['name'] as String,
                                      style: TextStyle(
                                        color: isActive ? t.accent : t.textDim,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                displayScore,
                                style: TextStyle(
                                  color: isActive ? t.textOnDark : t.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: t.monoFont,
                                ),
                              ),
                              if (isActive && status == 'playing')
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(color: t.accent, shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                if (currentTurnDarts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PubCard(
                      theme: t,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOUR EN COURS',
                            style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 1.4, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ...currentTurnDarts.map((d) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: t.accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: t.accent.withValues(alpha: 0.3), width: 1),
                                ),
                                child: Text(
                                  d['label'] as String? ?? '?',
                                  style: TextStyle(
                                    color: t.textOnDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: t.monoFont,
                                  ),
                                ),
                              )),
                              ...List.generate(3 - currentTurnDarts.length, (_) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: t.surface.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.2), width: 1),
                                ),
                                child: Text('—', style: TextStyle(color: t.textDim, fontSize: 16, fontFamily: t.monoFont)),
                              )),
                              const Spacer(),
                              Text(
                                '${currentTurnDarts.fold<int>(0, (s, d) => s + ((d['value'] as num?)?.toInt() ?? 0))}',
                                style: TextStyle(
                                  color: t.accent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: t.monoFont,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (winnerName != null) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '🏆 $winnerName gagne !',
                      style: TextStyle(
                        color: t.gold,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: t.displayFont,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          const Text('LIVE', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _WinBadge extends StatelessWidget {
  final AppThemeTokens t;
  const _WinBadge({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: t.gold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: t.gold.withValues(alpha: 0.5), width: 1),
      ),
      child: Text('VICTOIRE', style: TextStyle(color: t.gold, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}
