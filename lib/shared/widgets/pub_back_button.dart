import 'package:flutter/material.dart';
import '../../core/themes/theme_tokens.dart';

class PubBackButton extends StatelessWidget {
  final AppThemeTokens t;
  final VoidCallback onTap;

  const PubBackButton({super.key, required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final useBrackets = t.shape.bracketCta;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: useBrackets ? 10 : 8,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(t.shape.buttonRadius),
          border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.45), width: 1),
        ),
        child: useBrackets
            ? Text(
                '‹ back',
                style: TextStyle(
                  color: t.textOnDark,
                  fontSize: 12,
                  fontFamily: t.monoFont,
                  letterSpacing: 0.5,
                ),
              )
            : Icon(Icons.chevron_left_rounded, color: t.textOnDark, size: 22),
      ),
    );
  }
}
