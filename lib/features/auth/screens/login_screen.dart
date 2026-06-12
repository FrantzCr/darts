import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleGoogleSignIn() async {
    setState(() { _loading = true; _error = null; });
    signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);

    return PubScreen(
      theme: t,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎯', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 24),
                Text(
                  'Fléchettes',
                  style: TextStyle(
                    color: t.textOnDark,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    fontFamily: t.displayFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour jouer en ligne\net suivre les parties en direct',
                  style: TextStyle(color: t.textOnDark.withValues(alpha: 0.6), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _GoogleButton(t: t, loading: _loading, onTap: _handleGoogleSignIn),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Text(
                    'Continuer sans compte',
                    style: TextStyle(
                      color: t.textOnDark.withValues(alpha: 0.5),
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: t.textOnDark.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          color: t.surface.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(t.shape.buttonRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: t.textOnDark.withValues(alpha: 0.6)),
              )
            else
              _GoogleG(),
            const SizedBox(width: 12),
            Text(
              'Se connecter avec Google',
              style: TextStyle(color: t.textOnDark, fontSize: 15, fontWeight: FontWeight.w600),
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
      width: 20,
      height: 20,
      decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle),
      child: const Center(
        child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      ),
    );
  }
}
