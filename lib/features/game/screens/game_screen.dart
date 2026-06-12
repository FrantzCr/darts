import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/checkouts.dart';
import '../../../core/models/active_game_state.dart';
import '../../../core/models/dart_throw.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_avatar.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_button.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/dartboard_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);

    if (game == null) {
      return PubScreen(
        theme: t,
        child: Center(
          child: Text(l10n.noCurrentGame, style: TextStyle(color: t.textOnDark)),
        ),
      );
    }

    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: Stack(
        children: [
          SafeArea(
            child: isLandscape
                ? _LandscapeLayout(game: game, t: t)
                : _PortraitLayout(game: game, t: t),
          ),
          if (game.status == GameStatus.win) const _WinConfetti(),
        ],
      ),
    );
  }
}

class _PortraitLayout extends ConsumerWidget {
  final ActiveGameState game;
  final AppThemeTokens t;

  const _PortraitLayout({required this.game, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _TopBar(game: game, t: t),
        const SizedBox(height: 8),
        _ScoreBanner(game: game, t: t),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: TappableDartboardWidget(
              theme: t,
              lastHitId: game.lastHitId,
              turnDarts: game.turn,
              size: MediaQuery.of(context).size.width * 0.9,
              onHit: (dart) => ref.read(gameProvider.notifier).recordHit(dart),
              onMiss: (p) => ref.read(gameProvider.notifier).recordHit(DartThrow.miss(tapOffset: p)),
            ),
          ),
        ),
        if (game.isRtc) _RtcTargetHint(game: game, t: t) else _CheckoutHint(game: game, t: t),
        _TurnRow(game: game, t: t),
        const SizedBox(height: 8),
        _ActionButtons(game: game, t: t),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LandscapeLayout extends ConsumerWidget {
  final ActiveGameState game;
  final AppThemeTokens t;

  const _LandscapeLayout({required this.game, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardSize = MediaQuery.of(context).size.height * 0.85;
    return Row(
      children: [
        SizedBox(
          width: boardSize,
          child: Center(
            child: TappableDartboardWidget(
              theme: t,
              lastHitId: game.lastHitId,
              turnDarts: game.turn,
              size: boardSize,
              onHit: (dart) => ref.read(gameProvider.notifier).recordHit(dart),
              onMiss: (p) => ref.read(gameProvider.notifier).recordHit(DartThrow.miss(tapOffset: p)),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _TopBar(game: game, t: t),
              const SizedBox(height: 8),
              _ScoreBanner(game: game, t: t),
              const Spacer(),
              if (game.isRtc) _RtcTargetHint(game: game, t: t) else _CheckoutHint(game: game, t: t),
              _TurnRow(game: game, t: t),
              const SizedBox(height: 8),
              _ActionButtons(game: game, t: t),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _WinConfetti extends StatefulWidget {
  const _WinConfetti();

  @override
  State<_WinConfetti> createState() => _WinConfettiState();
}

class _WinConfettiState extends State<_WinConfetti> {
  late final ConfettiController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = ConfettiController(duration: const Duration(seconds: 4));
    _ctrl.play();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _ctrl,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 40,
        gravity: 0.15,
        emissionFrequency: 0.08,
        colors: const [
          Color(0xFFe53935),
          Color(0xFFFFD700),
          Color(0xFF43A047),
          Color(0xFF1E88E5),
          Color(0xFFFF6F00),
          Color(0xFF9C27B0),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _TopBar({required this.game, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final liveCode = ref.watch(liveGameCodeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          PubBackButton(t: t, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Text(
            '${game.isRtc ? 'Clock' : game.startScore} · ${l10n.roundLabel(game.round)}',
            style: TextStyle(
              color: t.textOnDark,
              fontSize: 14,
              fontFamily: t.monoFont,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          if (liveCode != null) ...[
            _LiveCodeBadge(code: liveCode, t: t),
            const SizedBox(width: 8),
          ],
          if (game.status == GameStatus.bust)
            _StatusPill(label: l10n.bust, color: Colors.red, t: t)
          else if (game.status == GameStatus.win)
            _StatusPill(label: l10n.win, color: t.gold, t: t),
        ],
      ),
    );
  }
}

class _LiveCodeBadge extends StatelessWidget {
  final String code;
  final AppThemeTokens t;
  const _LiveCodeBadge({required this.code, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          Text(
            code,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final AppThemeTokens t;
  const _StatusPill({required this.label, required this.color, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _ScoreBanner({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: game.players.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = game.players[i];
          final isActive = i == game.activeIndex;
          return _PlayerScoreCard(player: p, isActive: isActive, t: t, isRtc: game.isRtc);
        },
      ),
    );
  }
}

class _PlayerScoreCard extends StatelessWidget {
  final ActivePlayer player;
  final bool isActive;
  final AppThemeTokens t;
  final bool isRtc;
  const _PlayerScoreCard({required this.player, required this.isActive, required this.t, this.isRtc = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? t.surface : t.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(t.shape.cardRadius),
        border: Border.all(
          color: isActive ? t.accent : t.surfaceBorder,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PubAvatar(
            initials: player.player.initials,
            color: player.player.color,
            theme: t,
            size: 32,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.player.name,
                style: TextStyle(color: t.textDim, fontSize: 11),
              ),
              isRtc
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${player.score > 20 ? 20 : player.score - 1}',
                            style: TextStyle(color: t.text, fontSize: 28, fontWeight: FontWeight.w800, fontFamily: t.scoreboardFont, height: 1.1),
                          ),
                          TextSpan(
                            text: '/20',
                            style: TextStyle(color: t.textDim, fontSize: 14, fontFamily: t.monoFont, height: 1.1),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      '${player.score}',
                      style: TextStyle(
                        color: t.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: t.scoreboardFont,
                        height: 1.1,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TurnRow extends StatelessWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _TurnRow({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final dart = i < game.turn.length ? game.turn[i] : null;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _DartSlot(dart: dart, index: i, t: t, isBust: game.status == GameStatus.bust, isRtc: game.isRtc),
            ),
          );
        }),
      ),
    );
  }
}

class _DartSlot extends StatelessWidget {
  final DartThrow? dart;
  final int index;
  final AppThemeTokens t;
  final bool isBust;
  final bool isRtc;
  const _DartSlot({required this.dart, required this.index, required this.t, required this.isBust, this.isRtc = false});

  @override
  Widget build(BuildContext context) {
    final hasValue = dart != null;
    final isMiss = dart?.multiplier == DartMultiplier.miss;

    if (isRtc) {
      final hit = dart?.rtcHit ?? false;
      Color bg = hasValue
          ? (hit ? t.green.withValues(alpha: 0.2) : t.surfaceAlt)
          : t.surface.withValues(alpha: 0.3);
      Color border = hasValue
          ? (hit ? t.green : t.surfaceBorder)
          : t.surfaceBorder.withValues(alpha: 0.4);
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(t.shape.smRadius),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: hasValue
              ? hit
                  ? Icon(Icons.check_rounded, color: t.green, size: 24)
                  : Text(
                      isMiss ? 'M' : '${dart!.sector}',
                      style: TextStyle(color: t.textDim, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: t.monoFont),
                    )
              : Text('—', style: TextStyle(color: t.textDim, fontSize: 18, fontFamily: t.monoFont)),
        ),
      );
    }

    final label = dart?.label ?? '—';
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: hasValue
            ? (isBust ? Colors.red.withValues(alpha: 0.2) : t.surfaceAlt)
            : t.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(t.shape.smRadius),
        border: Border.all(
          color: hasValue ? (isBust ? Colors.red : t.surfaceBorder) : t.surfaceBorder.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isMiss ? t.textDim : t.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: t.monoFont,
              ),
            ),
            if (hasValue && !isMiss)
              Text(
                '+${dart!.value}',
                style: TextStyle(color: t.accent, fontSize: 10, fontFamily: t.monoFont),
              ),
          ],
        ),
      ),
    );
  }
}

class _RtcTargetHint extends StatelessWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _RtcTargetHint({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    if (game.status == GameStatus.win) return const SizedBox(height: 4);
    final target = game.rtcTarget.clamp(1, 20);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.my_location_rounded, color: t.accent, size: 16),
          const SizedBox(width: 8),
          Text(
            'Viser ',
            style: TextStyle(color: t.textDim, fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: t.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$target',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: t.monoFont,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '/ 20',
            style: TextStyle(color: t.textDim, fontSize: 14, fontFamily: t.monoFont),
          ),
        ],
      ),
    );
  }
}

class _CheckoutHint extends StatelessWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _CheckoutHint({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    if (game.status == GameStatus.win) return const SizedBox(height: 4);
    final projected = game.projected;
    if (projected < 1 || projected > 170) return const SizedBox(height: 4);

    final dartsLeft = 3 - game.turn.length;
    final routes = getCheckouts(projected, dartsLeft: dartsLeft);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.flag, color: t.gold, size: 17),
            const SizedBox(width: 6),
            Text(
              '$projected pts',
              style: TextStyle(color: t.gold, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: t.monoFont),
            ),
          ]),
          const SizedBox(height: 9),
          if (routes.isEmpty)
            Row(children: [
              Icon(Icons.do_not_disturb_alt, color: t.textDim, size: 16),
              const SizedBox(width: 7),
              Text(
                'Pas de sortie en $dartsLeft ${dartsLeft > 1 ? 'fléchettes' : 'fléchette'}',
                style: TextStyle(color: t.textDim, fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ])
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < routes.length; i++) ...[
                  if (i > 0) ...[
                    const SizedBox(width: 12),
                    Text('ou', style: TextStyle(color: t.textDim, fontSize: 14)),
                    const SizedBox(width: 12),
                  ],
                  Wrap(
                    spacing: 7,
                    children: routes[i].map((step) {
                      final info = formatStep(step);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: _chipColor(info.kind, t), borderRadius: BorderRadius.circular(8)),
                        child: Text(info.label, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, fontFamily: t.monoFont)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Color _chipColor(String kind, AppThemeTokens t) => switch (kind) {
    'double' => t.accent,
    'triple' => t.green,
    'bull'   => t.gold,
    _        => t.textDim,
  };
}

class _ActionButtons extends ConsumerWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _ActionButtons({required this.game, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(gameProvider.notifier);
    final canUndo = game.turn.isNotEmpty && game.status != GameStatus.win;
    final canValidate = game.turn.isNotEmpty && game.status != GameStatus.win;

    if (game.status == GameStatus.win) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PubButton(
          label: l10n.viewResults,
          theme: t,
          kind: PubButtonKind.gold,
          expanded: true,
          onPressed: () => context.go('/result'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: PubButton(
              label: l10n.undo,
              theme: t,
              kind: PubButtonKind.ghost,
              onPressed: canUndo ? () => notifier.undo() : null,
              icon: Icons.undo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: PubButton(
              label: l10n.validate,
              theme: t,
              kind: PubButtonKind.primary,
              onPressed: canValidate ? () => notifier.validate() : null,
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }
}
