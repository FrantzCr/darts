import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/firestore_game_service.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_screen.dart';

class ActiveGamesScreen extends ConsumerWidget {
  const ActiveGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);
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
                    'Parties en cours',
                    style: TextStyle(
                      color: t.textOnDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: t.displayFont,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showJoinByCode(context, t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: t.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(t.shape.buttonRadius),
                        border: Border.all(color: t.accent.withValues(alpha: 0.4), width: 1),
                      ),
                      child: Text(
                        'Code',
                        style: TextStyle(color: t.accent, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            authUser.when(
              data: (user) {
                if (user == null) return _NotSignedIn(t: t);
                return _GamesList(t: t);
              },
              loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinByCode(BuildContext context, AppThemeTokens t) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(t.shape.cardRadius)),
        title: Text('Rejoindre avec un code', style: TextStyle(color: t.textOnDark, fontSize: 16, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          maxLength: 6,
          style: TextStyle(color: t.textOnDark, fontSize: 24, letterSpacing: 6, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: 'DART42',
            hintStyle: TextStyle(color: t.textDim, letterSpacing: 4),
            counterStyle: TextStyle(color: t.textDim),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: t.surfaceBorder)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: t.accent, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annuler', style: TextStyle(color: t.textDim)),
          ),
          TextButton(
            onPressed: () async {
              final code = controller.text.trim().toUpperCase();
              if (code.isEmpty) return;
              Navigator.of(ctx).pop();
              final gameId = await FirestoreGameService.findGameByCode(code);
              if (gameId != null && context.mounted) {
                context.go('/live/$gameId');
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Code introuvable : $code'),
                    backgroundColor: t.bg,
                  ),
                );
              }
            },
            child: Text('Rejoindre', style: TextStyle(color: t.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _NotSignedIn extends StatelessWidget {
  final AppThemeTokens t;
  const _NotSignedIn({required this.t});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, color: t.textDim, size: 48),
              const SizedBox(height: 16),
              Text(
                'Connectez-vous pour voir\nles parties en direct',
                style: TextStyle(color: t.textOnDark, fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(t.shape.buttonRadius),
                  ),
                  child: Text(
                    'Se connecter',
                    style: TextStyle(color: t.textOnDark, fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GamesList extends StatelessWidget {
  final AppThemeTokens t;
  const _GamesList({required this.t});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreGameService.watchActiveGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data ?? [];
          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_bar_outlined, color: t.textDim, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune partie en cours',
                    style: TextStyle(color: t.textDim, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: games.length,
            itemBuilder: (ctx, i) => _GameCard(game: games[i], t: t),
          );
        },
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Map<String, dynamic> game;
  final AppThemeTokens t;
  const _GameCard({required this.game, required this.t});

  @override
  Widget build(BuildContext context) {
    final players = (game['players'] as List).cast<Map<String, dynamic>>();
    final state = game['state'] as Map<String, dynamic>?;
    final hostName = game['hostName'] as String? ?? '';
    final gameMode = game['gameMode'] as String? ?? 'classic';
    final startScore = game['startScore'] as int? ?? 301;
    final round = state?['round'] as int? ?? 1;
    final code = game['code'] as String? ?? '';

    return GestureDetector(
      onTap: () => context.go('/live/${game['id']}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(t.shape.cardRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _LiveBadge(),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: t.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    gameMode == 'rtc' ? 'Clock' : '$startScore',
                    style: TextStyle(color: t.accent, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                const Spacer(),
                Text(
                  code,
                  style: TextStyle(
                    color: t.textDim, fontSize: 12,
                    fontWeight: FontWeight.w700, letterSpacing: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    players.map((p) => p['name']).join(' · '),
                    style: TextStyle(color: t.textOnDark, fontSize: 14, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Manche $round',
                  style: TextStyle(color: t.textDim, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Par $hostName',
              style: TextStyle(color: t.textDim, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
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
