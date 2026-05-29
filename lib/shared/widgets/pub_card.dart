import 'package:flutter/material.dart';
import '../../core/themes/theme_tokens.dart';

class PubCard extends StatelessWidget {
  final AppThemeTokens theme;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const PubCard({
    super.key,
    required this.theme,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? theme.surface;
    final radius = theme.shape.cardRadius;
    final hasTicks = theme.shape.cornerTicks;

    Widget card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: theme.surfaceBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
            if (hasTicks) IgnorePointer(child: _CornerTicks(color: theme.accent)),
          ],
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

class _CornerTicks extends StatelessWidget {
  final Color color;
  const _CornerTicks({required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _TickPainter(color: color)),
    );
  }
}

class _TickPainter extends CustomPainter {
  final Color color;
  _TickPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const len = 10.0;
    const gap = 3.0;

    void tick(double x, double y, bool flipH, bool flipV) {
      final dx = flipH ? -1 : 1;
      final dy = flipV ? -1 : 1;
      canvas.drawLine(Offset(x, y + gap * dy), Offset(x, y + (gap + len) * dy), paint);
      canvas.drawLine(Offset(x + gap * dx, y), Offset(x + (gap + len) * dx, y), paint);
    }

    tick(0, 0, false, false);
    tick(size.width, 0, true, false);
    tick(0, size.height, false, true);
    tick(size.width, size.height, true, true);
  }

  @override
  bool shouldRepaint(_TickPainter old) => old.color != color;
}
