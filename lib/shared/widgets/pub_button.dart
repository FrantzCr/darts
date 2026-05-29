import 'package:flutter/material.dart';
import '../../core/themes/theme_tokens.dart';

enum PubButtonKind { primary, gold, ghost, text }

class PubButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PubButtonKind kind;
  final AppThemeTokens theme;
  final bool expanded;
  final IconData? icon;
  final bool small;

  const PubButton({
    super.key,
    required this.label,
    required this.theme,
    this.onPressed,
    this.kind = PubButtonKind.primary,
    this.expanded = false,
    this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final radius = t.shape.buttonRadius;
    final useBrackets = t.shape.bracketCta && kind == PubButtonKind.primary;
    final displayLabel = useBrackets ? '[ $label ]' : label;

    final vPad = small ? 10.0 : 14.0;
    final hPad = small ? 16.0 : 24.0;
    final fontSize = small ? 13.0 : 15.0;

    Color bg;
    Color fg;
    Color? borderColor;

    switch (kind) {
      case PubButtonKind.primary:
        bg = t.accent;
        fg = t.textOnDark;
      case PubButtonKind.gold:
        bg = t.gold;
        fg = t.onGold;
      case PubButtonKind.ghost:
        bg = Colors.transparent;
        fg = t.textOnDark;
        borderColor = t.surfaceBorder;
      case PubButtonKind.text:
        bg = Colors.transparent;
        fg = t.textDim;
    }

    final textStyle = TextStyle(
      color: fg,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );

    Widget inner = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, color: fg, size: fontSize + 2), const SizedBox(width: 8)],
        Text(displayLabel, style: textStyle),
      ],
    );

    Widget button = GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.4 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
          ),
          child: inner,
        ),
      ),
    );

    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
