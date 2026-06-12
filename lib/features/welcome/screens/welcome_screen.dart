import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/pub_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Auto-redirect if already signed in once auth resolves
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authUserProvider).value;
      if (user != null && mounted) context.go('/');
    });
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() { _loading = true; _error = null; });
    // signInWithRedirect navigates the page to Google — no await needed
    signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);

    // Watch auth — redirect as soon as a user is detected
    ref.listen(authUserProvider, (_, next) {
      next.whenData((user) {
        if (user != null && mounted) context.go('/');
      });
    });

    final authAsync = ref.watch(authUserProvider);
    if (authAsync.isLoading) {
      return PubScreen(
        theme: t,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return PubScreen(
      theme: t,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _Hero(t: t),
            const Spacer(flex: 2),
            _Features(t: t),
            const Spacer(flex: 1),
            _Actions(
              t: t,
              loading: _loading,
              error: _error,
              onGoogleSignIn: _handleGoogleSignIn,
              onSkip: () => context.go('/'),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final AppThemeTokens t;
  const _Hero({required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('🎯', style: TextStyle(fontSize: 72, shadows: [
          Shadow(color: t.accent.withValues(alpha: 0.4), blurRadius: 24),
        ])),
        const SizedBox(height: 20),
        Text(
          'Fléchettes',
          style: TextStyle(
            color: t.textOnDark,
            fontSize: 44,
            fontWeight: FontWeight.w800,
            fontFamily: t.displayFont,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Jouez, regardez, progressez.',
          style: TextStyle(
            color: t.textOnDark.withValues(alpha: 0.55),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _Features extends StatelessWidget {
  final AppThemeTokens t;
  const _Features({required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          _FeatureChip(icon: Icons.show_chart_rounded, label: 'Stats', t: t),
          const SizedBox(width: 10),
          _FeatureChip(icon: Icons.people_rounded, label: 'Joueurs', t: t),
          const SizedBox(width: 10),
          _LiveChip(t: t),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppThemeTokens t;
  const _FeatureChip({required this.icon, required this.label, required this.t});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(t.shape.cardRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: t.textOnDark.withValues(alpha: 0.7), size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: t.textOnDark.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  final AppThemeTokens t;
  const _LiveChip({required this.t});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(t.shape.cardRadius),
          border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Spectateur',
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final AppThemeTokens t;
  final bool loading;
  final String? error;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSkip;
  const _Actions({
    required this.t,
    required this.loading,
    required this.error,
    required this.onGoogleSignIn,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          _GoogleButton(t: t, loading: loading, onTap: onGoogleSignIn),
          const SizedBox(height: 10),
          Text(
            'Sauvegarde cloud · Parties en direct · Stats partagées',
            style: TextStyle(
              color: t.textOnDark.withValues(alpha: 0.35),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'Continuer sans compte',
              style: TextStyle(
                color: t.textOnDark.withValues(alpha: 0.45),
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: t.textOnDark.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final AppThemeTokens t;
  final bool loading;
  final VoidCallback onTap;
  const _GoogleButton({required this.t, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(t.shape.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
              )
            else
              _GoogleG(),
            const SizedBox(width: 12),
            Text(
              'Se connecter avec Google',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle),
      child: const Center(
        child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      ),
    );
  }
}
