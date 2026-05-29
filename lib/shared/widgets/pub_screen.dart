import 'package:flutter/material.dart';
import '../../core/themes/theme_tokens.dart';

class PubScreen extends StatelessWidget {
  final AppThemeTokens theme;
  final Widget child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? fabLocation;

  const PubScreen({
    super.key,
    required this.theme,
    required this.child,
    this.floatingActionButton,
    this.fabLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.bg,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: fabLocation ?? FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          if (theme.shape.texture == 'diagonal') IgnorePointer(child: _DiagonalTexture(color: theme.surfaceBorder)),
          if (theme.shape.texture == 'grid') IgnorePointer(child: _GridTexture(color: theme.surfaceBorder)),
          child,
        ],
      ),
    );
  }
}

class _DiagonalTexture extends StatelessWidget {
  final Color color;
  const _DiagonalTexture({required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _DiagonalPainter(color: color)),
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  final Color color;
  _DiagonalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const spacing = 24.0;
    final count = (size.width + size.height) ~/ spacing + 2;
    for (int i = -2; i < count; i++) {
      final x = i * spacing.toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalPainter old) => old.color != color;
}

class _GridTexture extends StatelessWidget {
  final Color color;
  const _GridTexture({required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _GridPainter(color: color)),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;
    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
