import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/dartboard_geometry.dart';
import '../../../core/models/dart_throw.dart';
import '../../../core/themes/theme_tokens.dart';

class DartboardWidget extends StatelessWidget {
  final AppThemeTokens theme;
  final void Function(DartThrow dart) onHit;
  final void Function() onMiss;
  final String? lastHitId;
  final double size;

  const DartboardWidget({
    super.key,
    required this.theme,
    required this.onHit,
    required this.onMiss,
    this.lastHitId,
    this.size = 360,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        // Detect tap outside the board circle → miss
        final center = Offset(size / 2, size / 2);
        final dist = (details.localPosition - center).distance;
        final scale = size / 400; // viewBox is 400×400
        if (dist > BoardRadii.outer * scale) {
          onMiss();
        }
      },
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _DartboardPainter(
            tokens: theme.board,
            lastHitId: lastHitId,
            onHit: onHit,
          ),
          child: SizedBox(width: size, height: size),
        ),
      ),
    );
  }
}

class _DartboardPainter extends CustomPainter {
  final BoardTokens tokens;
  final String? lastHitId;
  final void Function(DartThrow) onHit;
  final List<DartThrow> turnDarts;

  _DartboardPainter({
    required this.tokens,
    this.lastHitId,
    required this.onHit,
    this.turnDarts = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 400;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);

    _drawBoard(canvas);
    _drawNumbers(canvas);
    _drawDartDots(canvas);
  }

  void _drawBoard(Canvas canvas) {
    final c = tokens;

    // Outer rim
    canvas.drawCircle(Offset.zero, BoardRadii.outer + 8, Paint()..color = c.rim);

    // Miss zone background (outer ring between rim and double)
    canvas.drawCircle(Offset.zero, BoardRadii.outer, Paint()..color = c.miss);

    // 20 sectors
    for (int i = 0; i < kSectorOrder.length; i++) {
      _drawSector(canvas, i);
    }

    // Outer bull (25)
    final outerBullPaint = Paint()..color = c.outerBull;
    final wirePaint = Paint()
      ..color = c.wire
      ..strokeWidth = c.wireWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset.zero, BoardRadii.outerBull, outerBullPaint);
    canvas.drawCircle(Offset.zero, BoardRadii.outerBull, wirePaint);

    // Bullseye (50) — treated as double for win purposes
    final bullPaint = Paint()..color = c.bull;
    canvas.drawCircle(Offset.zero, BoardRadii.bull, bullPaint);
    canvas.drawCircle(Offset.zero, BoardRadii.bull, wirePaint);

    // Hit highlight overlay
    if (lastHitId != null) {
      _drawHitHighlight(canvas, lastHitId!);
    }
  }

  void _drawSector(Canvas canvas, int i) {
    final c = tokens;
    final val = kSectorOrder[i];
    final angles = sectorAngles(i);

    final wirePaint = Paint()
      ..color = c.wire
      ..strokeWidth = c.wireWidth
      ..style = PaintingStyle.stroke;

    void drawZone(String zoneId, double r1, double r2, Color fill, DartMultiplier mult, int value) {
      final path = _ringPath(r1, r2, angles.a1, angles.a2);
      final fillPaint = Paint()..color = fill;
      if (lastHitId == zoneId) {
        fillPaint.color = fill.withValues(alpha: 0.85);
        canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.25));
      }
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, wirePaint);
    }

    final isEven = i % 2 == 0;
    final singleFill = isEven ? c.wedgeA : c.wedgeB;
    final scoreFill = isEven ? c.scoreA : c.scoreB;

    // single-out (between triple outer and double inner)
    drawZone('s$val-single-out', BoardRadii.tripleO, BoardRadii.doubleI, singleFill, DartMultiplier.single, val);
    // double ring
    drawZone('s$val-double', BoardRadii.doubleI, BoardRadii.doubleO, scoreFill, DartMultiplier.double, val * 2);
    // triple ring
    drawZone('s$val-triple', BoardRadii.tripleI, BoardRadii.tripleO, scoreFill, DartMultiplier.triple, val * 3);
    // single-in (between outer bull and triple inner)
    drawZone('s$val-single-in', BoardRadii.outerBull, BoardRadii.tripleI, singleFill, DartMultiplier.single, val);
  }

  void _drawHitHighlight(Canvas canvas, String hitId) {
    // Draw a bright overlay on the hit zone
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..blendMode = BlendMode.plus;

    if (hitId == 'bull-50') {
      canvas.drawCircle(Offset.zero, BoardRadii.bull, paint);
      return;
    }
    if (hitId == 'bull-25') {
      canvas.drawCircle(Offset.zero, BoardRadii.outerBull, paint);
      canvas.drawCircle(Offset.zero, BoardRadii.bull, Paint()..color = tokens.bull);
      return;
    }
    if (hitId == 'miss') return;

    // Parse zone id: 's{val}-{ring}'
    final parts = hitId.split('-');
    if (parts.length < 2) return;
    final val = int.tryParse(parts[0].substring(1));
    if (val == null) return;
    final ring = parts.sublist(1).join('-');
    final idx = kSectorOrder.indexOf(val);
    if (idx < 0) return;
    final angles = sectorAngles(idx);

    Path path;
    switch (ring) {
      case 'single-out':
        path = _ringPath(BoardRadii.tripleO, BoardRadii.doubleI, angles.a1, angles.a2);
      case 'double':
        path = _ringPath(BoardRadii.doubleI, BoardRadii.doubleO, angles.a1, angles.a2);
      case 'triple':
        path = _ringPath(BoardRadii.tripleI, BoardRadii.tripleO, angles.a1, angles.a2);
      case 'single-in':
        path = _ringPath(BoardRadii.outerBull, BoardRadii.tripleI, angles.a1, angles.a2);
      default:
        return;
    }
    canvas.drawPath(path, paint);
  }

  void _drawDartDots(Canvas canvas) {
    for (int i = 0; i < turnDarts.length; i++) {
      final offset = turnDarts[i].tapOffset;
      if (offset == null) continue;
      // Shadow
      canvas.drawCircle(offset, 6.5, Paint()..color = const Color(0x88000000));
      // White pin head
      canvas.drawCircle(offset, 5.0, Paint()..color = Colors.white);
      // Colored center by dart order
      final dotColors = [const Color(0xFFe53935), const Color(0xFF1E88E5), const Color(0xFF43A047)];
      canvas.drawCircle(offset, 2.5, Paint()..color = dotColors[i % dotColors.length]);
    }
  }

  void _drawNumbers(Canvas canvas) {
    final c = tokens;
    for (int i = 0; i < kSectorOrder.length; i++) {
      final val = kSectorOrder[i];
      final angles = sectorAngles(i);
      final numPos = polar(182, angles.center);

      final tp = TextPainter(
        text: TextSpan(
          text: '$val',
          style: TextStyle(
            color: c.numColor,
            fontSize: c.numSize,
            fontWeight: c.numWeight,
            letterSpacing: c.numTracking,
            fontFamily: c.numFont,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, numPos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  Path _ringPath(double r1, double r2, double a1, double a2) {
    final p1 = polar(r2, a1);
    final p2 = polar(r2, a2);
    final p3 = polar(r1, a2);
    final p4 = polar(r1, a1);

    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..arcToPoint(p2, radius: Radius.circular(r2), clockwise: true)
      ..lineTo(p3.dx, p3.dy)
      ..arcToPoint(p4, radius: Radius.circular(r1), clockwise: false)
      ..close();
  }

  @override
  bool shouldRepaint(_DartboardPainter old) =>
      old.lastHitId != lastHitId || old.turnDarts != turnDarts || old.tokens != tokens;
}

// Hit-test version — maps tap coordinates to dart throw
class TappableDartboardWidget extends StatelessWidget {
  final AppThemeTokens theme;
  final void Function(DartThrow dart) onHit;
  final void Function(Offset viewboxPos) onMiss;
  final String? lastHitId;
  final double size;
  final List<DartThrow> turnDarts;

  const TappableDartboardWidget({
    super.key,
    required this.theme,
    required this.onHit,
    required this.onMiss,
    this.lastHitId,
    this.size = 360,
    this.turnDarts = const [],
  });

  DartThrow? _hitTest(Offset localPos) {
    final center = Offset(size / 2, size / 2);
    final scale = 400 / size; // convert back to viewBox coords
    final p = (localPos - center) * scale;
    final r = p.distance;

    // Snap margin (viewBox units): narrow rings get this extra radius on each side.
    // Triple and double rings are 10 units wide; +12 each side ≈ 3× larger hitbox.
    const snap = 12.0;

    if (r > BoardRadii.outer) return null;
    // Beyond double ring + snap margin → miss
    if (r > BoardRadii.doubleO + snap) return null;

    // ── Bull zones (priority, checked before sector logic) ───────
    if (r <= BoardRadii.bull + snap) {
      return DartThrow(id: 'bull-50', sector: 50, multiplier: DartMultiplier.double, value: 50, tapOffset: p);
    }
    if (r <= BoardRadii.outerBull + snap) {
      return DartThrow(id: 'bull-25', sector: 25, multiplier: DartMultiplier.single, value: 25, tapOffset: p);
    }

    // Determine sector by angle
    double angleDeg = atan2(p.dy, p.dx) * 180 / pi;
    angleDeg = (angleDeg + 90 + 360) % 360;
    int sectorIdx = ((angleDeg + 9) ~/ 18) % 20;
    final val = kSectorOrder[sectorIdx];

    String ring;
    DartMultiplier mult;
    int value;

    // ── Double ring (snapped inward and outward) ──────────────────
    if (r >= BoardRadii.doubleI - snap && r <= BoardRadii.doubleO + snap) {
      ring = 'double';
      mult = DartMultiplier.double;
      value = val * 2;
    // ── Triple ring (snapped inward and outward) ──────────────────
    } else if (r >= BoardRadii.tripleI - snap && r <= BoardRadii.tripleO + snap) {
      ring = 'triple';
      mult = DartMultiplier.triple;
      value = val * 3;
    // ── Single-out (remaining gap between triple+snap and double-snap) ──
    } else if (r > BoardRadii.tripleO + snap) {
      ring = 'single-out';
      mult = DartMultiplier.single;
      value = val;
    // ── Single-in (between outerBull+snap and tripleI-snap) ───────
    } else {
      ring = 'single-in';
      mult = DartMultiplier.single;
      value = val;
    }

    return DartThrow(
      id: 's$val-$ring',
      sector: val,
      multiplier: mult,
      value: value,
      tapOffset: p,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final center = Offset(size / 2, size / 2);
        final scale = 400 / size;
        final viewboxPos = (details.localPosition - center) * scale;
        final dart = _hitTest(details.localPosition);
        if (dart == null) {
          onMiss(viewboxPos);
        } else {
          onHit(dart);
        }
      },
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _DartboardPainter(
            tokens: theme.board,
            lastHitId: lastHitId,
            onHit: onHit,
            turnDarts: turnDarts,
          ),
        ),
      ),
    );
  }
}
