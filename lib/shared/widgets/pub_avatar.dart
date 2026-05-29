import 'package:flutter/material.dart';
import '../../core/themes/theme_tokens.dart';

class PubAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  final bool goldRing;
  final AppThemeTokens theme;

  const PubAvatar({
    super.key,
    required this.initials,
    required this.color,
    required this.theme,
    this.size = 40,
    this.goldRing = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: goldRing
            ? Border.all(color: theme.gold, width: 2.5)
            : null,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
    return circle;
  }
}
