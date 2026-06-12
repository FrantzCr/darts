import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gage.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../l10n/app_localizations.dart';

const _kSegmentColors = [
  Color(0xFFE53935),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFFF8F00),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
  Color(0xFF6D4C41),
  Color(0xFF3949AB),
];

class SpinWheelOverlay extends ConsumerStatefulWidget {
  final List<Gage> gages;
  final VoidCallback onDismiss;

  const SpinWheelOverlay({super.key, required this.gages, required this.onDismiss});

  @override
  ConsumerState<SpinWheelOverlay> createState() => _SpinWheelOverlayState();
}

class _SpinWheelOverlayState extends ConsumerState<SpinWheelOverlay> with SingleTickerProviderStateMixin {
  double _angle = 0.0; // total clockwise rotation in degrees
  bool _hasSpun = false;
  Gage? _winner;
  late final AnimationController _ctrl;
  Animation<double>? _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500));
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final n = widget.gages.length;
        final seg = 360.0 / n;
        // Pointer at top sees: (360 - angle%360) % 360 on the original wheel
        final idx = (((360.0 - _angle % 360.0) % 360.0) / seg).floor() % n;
        setState(() => _winner = widget.gages[idx]);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _spin() {
    if (_hasSpun || widget.gages.isEmpty) return;
    setState(() => _hasSpun = true);

    final n = widget.gages.length;
    final seg = 360.0 / n;
    final winnerIdx = Random().nextInt(n);

    // Land in center of winner segment:
    // pointer sees (360 - targetAngle%360)%360 → we want = winnerIdx*seg + seg/2
    // => targetAngle%360 = (360 - winnerIdx*seg - seg/2) % 360
    final targetMod = (360.0 - winnerIdx * seg - seg / 2.0) % 360.0;
    final currentMod = _angle % 360.0;
    var extra = (targetMod - currentMod + 360.0) % 360.0;
    if (extra < 5.0) extra += 360.0;
    final targetAngle = _angle + 6.0 * 360.0 + extra;

    _anim = Tween<double>(begin: _angle, end: targetAngle)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.decelerate))
      ..addListener(() => setState(() => _angle = _anim!.value));

    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final wheelSize = (size.width * 0.82).clamp(200.0, 420.0);
    final isSpinning = _hasSpun && _winner == null;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {}, // absorb taps so nothing passes through to game
        child: Container(
          color: Colors.black.withValues(alpha: 0.88),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _winner != null ? l10n.yourForfeit : (isSpinning ? '...' : l10n.spinInstruction),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Wheel
                GestureDetector(
                  onPanEnd: (d) {
                    if (d.velocity.pixelsPerSecond.distance > 80) _spin();
                  },
                  onTapUp: (_) => _spin(),
                  child: SizedBox(
                    width: wheelSize + 24,
                    height: wheelSize + 24,
                    child: CustomPaint(
                      painter: _WheelPainter(gages: widget.gages, angle: _angle),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Winner card
                if (_winner != null) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20)],
                    ),
                    child: Text(
                      _winner!.text,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: t.accent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: widget.onDismiss,
                        child: Text(
                          l10n.continueGame,
                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ] else if (!_hasSpun) ...[
                  // Swipe hint icon
                  Icon(Icons.swipe_rounded, color: Colors.white.withValues(alpha: 0.4), size: 36),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _WheelPainter extends CustomPainter {
  final List<Gage> gages;
  final double angle;

  const _WheelPainter({required this.gages, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final n = gages.length;
    if (n == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 12; // leave room for pointer
    final segRad = (2 * pi) / n;
    final startOffset = -pi / 2; // 12 o'clock

    // ── Rotating wheel ────────────────────────────────────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * pi / 180);

    for (int i = 0; i < n; i++) {
      final start = startOffset + i * segRad;

      // Wedge fill
      final paint = Paint()..color = _kSegmentColors[i % _kSegmentColors.length];
      canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: radius), start, segRad, true, paint);

      // Wedge border
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        start,
        segRad,
        true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Number label (rotated along radius)
      final labelAngle = start + segRad / 2;
      final labelR = radius * 0.68;
      final labelPos = Offset(cos(labelAngle) * labelR, sin(labelAngle) * labelR);

      canvas.save();
      canvas.translate(labelPos.dx, labelPos.dy);
      canvas.rotate(labelAngle + pi / 2);

      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      canvas.restore();
    }

    // Center cap
    canvas.drawCircle(Offset.zero, radius * 0.10, Paint()..color = Colors.white);
    canvas.drawCircle(Offset.zero, radius * 0.07, Paint()..color = const Color(0xFF1A1A1A));

    canvas.restore();

    // ── Outer ring (fixed) ────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      radius + 4,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // ── Pointer triangle (fixed, points downward at top of wheel) ─────────
    final tipY = center.dy - radius - 2;
    final baseY = center.dy - radius + 16;
    final path = Path()
      ..moveTo(center.dx - 10, baseY)
      ..lineTo(center.dx + 10, baseY)
      ..lineTo(center.dx, tipY)
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.angle != angle || old.gages != gages;
}
