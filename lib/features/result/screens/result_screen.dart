import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/active_game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/game/providers/game_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_avatar.dart';
import '../../../shared/widgets/pub_button.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final t = ref.watch(activeThemeTokensProvider);

    if (game == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
      return const SizedBox.shrink();
    }

    final winner = game.players.firstWhere(
      (p) => p.score == 0,
      orElse: () => game.players.first,
    );
    final ranked = [...game.players]..sort((a, b) => a.score.compareTo(b.score));

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _WinnerRosette(player: winner, t: t),
              const SizedBox(height: 32),
              _RankingList(players: ranked, t: t),
              const SizedBox(height: 24),
              _StatGrid(game: game, t: t),
              const SizedBox(height: 32),
              _FooterButtons(t: t, game: game, ref: ref),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinnerRosette extends StatelessWidget {
  final ActivePlayer player;
  final AppThemeTokens t;
  const _WinnerRosette({required this.player, required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n.winnerIs.toUpperCase(),
          style: TextStyle(
            color: t.gold,
            fontSize: 11,
            letterSpacing: 3,
            fontFamily: t.monoFont,
          ),
        ),
        const SizedBox(height: 16),
        PubAvatar(
          initials: player.player.initials,
          color: player.player.color,
          theme: t,
          size: 88,
          goldRing: true,
        ),
        const SizedBox(height: 12),
        Text(
          player.player.name,
          style: TextStyle(
            color: t.textOnDark,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            fontFamily: t.displayFont,
          ),
        ),
      ],
    );
  }
}

class _RankingList extends StatelessWidget {
  final List<ActivePlayer> players;
  final AppThemeTokens t;
  const _RankingList({required this.players, required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: players.asMap().entries.map((entry) {
        final i = entry.key;
        final p = entry.value;
        final isWinner = p.score == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: isWinner ? t.gold : t.textDim,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              PubAvatar(initials: p.player.initials, color: p.player.color, theme: t, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  p.player.name,
                  style: TextStyle(
                    color: t.textOnDark,
                    fontSize: 16,
                    fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              if (isWinner)
                Icon(Icons.emoji_events, color: t.gold, size: 20)
              else
                Text(
                  l10n.remainingPoints(p.score),
                  style: TextStyle(color: t.textDim, fontSize: 13, fontFamily: t.monoFont),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final ActiveGameState game;
  final AppThemeTokens t;
  const _StatGrid({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final durationSec = DateTime.now().difference(game.startedAt).inSeconds;
    final mins = durationSec ~/ 60;
    final secs = durationSec % 60;

    final stats = [
      (l10n.round, '${game.round}'),
      (l10n.darts, '${game.turn.length + (game.round - 1) * 3 * game.players.length}'),
      (l10n.duration, '${mins}m${secs.toString().padLeft(2, '0')}s'),
      (l10n.players, '${game.players.length}'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: stats.map((s) => Container(
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(t.shape.smRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.$2, style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w800, fontFamily: t.monoFont)),
            Text(s.$1, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.55), fontSize: 11)),
          ],
        ),
      )).toList(),
    );
  }
}

class _FooterButtons extends StatelessWidget {
  final AppThemeTokens t;
  final ActiveGameState game;
  final WidgetRef ref;
  const _FooterButtons({required this.t, required this.game, required this.ref});

  void _showRematchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _RematchOrderSheet(
        game: game,
        onStart: (players) {
          ref.read(gameProvider.notifier).startGame(
            players,
            startScore: game.startScore,
            gameMode: game.gameMode,
          );
          context.go('/game');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PubButton(
          label: l10n.rematch,
          theme: t,
          kind: PubButtonKind.gold,
          expanded: true,
          icon: Icons.replay,
          onPressed: () => _showRematchSheet(context),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PubButton(
                label: l10n.newGameBtn,
                theme: t,
                kind: PubButtonKind.ghost,
                onPressed: () {
                  ref.read(gameProvider.notifier).reset();
                  context.go('/new-game');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PubButton(
                label: l10n.homeBtn,
                theme: t,
                kind: PubButtonKind.text,
                onPressed: () {
                  ref.read(gameProvider.notifier).reset();
                  context.go('/');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Bottom sheet ─────────────────────────────────────────────────────────────

class _RematchOrderSheet extends ConsumerStatefulWidget {
  final ActiveGameState game;
  final void Function(List<Player> players) onStart;
  const _RematchOrderSheet({required this.game, required this.onStart});

  @override
  ConsumerState<_RematchOrderSheet> createState() => _RematchOrderSheetState();
}

class _RematchOrderSheetState extends ConsumerState<_RematchOrderSheet> {
  late List<Player> _players;

  @override
  void initState() {
    super.initState();
    _players = widget.game.players.map((p) => p.player).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: t.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: t.surfaceBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.rematchOrderTitle,
            style: TextStyle(
              color: t.textOnDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: t.displayFont,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dragToReorder,
            style: TextStyle(color: t.textDim, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _players.removeAt(oldIndex);
                _players.insert(newIndex, item);
              });
            },
            children: [
              for (int i = 0; i < _players.length; i++)
                _PlayerOrderTile(
                  key: ValueKey(_players[i].id),
                  index: i,
                  player: _players[i],
                  t: t,
                ),
            ],
          ),
          const SizedBox(height: 20),
          PubButton(
            label: l10n.startGame,
            theme: t,
            kind: PubButtonKind.gold,
            expanded: true,
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              widget.onStart(_players);
            },
          ),
        ],
      ),
    );
  }
}

class _PlayerOrderTile extends StatelessWidget {
  final int index;
  final Player player;
  final AppThemeTokens t;
  const _PlayerOrderTile({super.key, required this.index, required this.player, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(t.shape.smRadius),
        border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              style: TextStyle(color: t.textDim, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: t.monoFont),
            ),
          ),
          const SizedBox(width: 10),
          PubAvatar(initials: player.initials, color: player.color, theme: t, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(color: t.textOnDark, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.drag_handle_rounded, color: t.textDim, size: 22),
          ),
        ],
      ),
    );
  }
}
