import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gage.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../l10n/app_localizations.dart';

// Dartboard palette
const _kDartBlack = Color(0xFF1C1C1C);
const _kDartCream = Color(0xFFF2EDD0);
const _kDartRed = Color(0xFFB71C1C);
const _kDartGreen = Color(0xFF1B5E20);
const _kBullGreen = Color(0xFF2E7D32);
const _kBullRed = Color(0xFFC62828);

class SpinWheelOverlay extends ConsumerStatefulWidget {
  final List<Gage> gages;
  final VoidCallback onDismiss;

  const SpinWheelOverlay({super.key, required this.gages, required this.onDismiss});

  @override
  ConsumerState<SpinWheelOverlay> createState() => _SpinWheelOverlayState();
}

class _SpinWheelOverlayState extends ConsumerState<SpinWheelOverlay>
    with SingleTickerProviderStateMixin {
  double _angle = 0.0;
  bool _hasSpun = false;
  Gage? _winner;
  late final AnimationController _ctrl;
  Animation<double>? _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4500));
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final n = widget.gages.length;
        final seg = 360.0 / n;
        final idx =
            (((360.0 - _angle % 360.0) % 360.0) / seg).floor() % n;
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

    final targetMod =
        (360.0 - winnerIdx * seg - seg / 2.0) % 360.0;
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
    final wheelSize =
        min(size.width * 0.94, size.height * 0.60).clamp(260.0, 540.0);
    final isSpinning = _hasSpun && _winner == null;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.black.withValues(alpha: 0.92),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 18),

                // ── Title ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _winner != null
                        ? l10n.yourForfeit
                        : isSpinning
                            ? '...'
                            : l10n.spinInstruction,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Wheel ──────────────────────────────────────────────
                GestureDetector(
                  onPanEnd: (d) {
                    if (d.velocity.pixelsPerSecond.distance > 80) _spin();
                  },
                  onTapUp: (_) => _spin(),
                  child: SizedBox(
                    width: wheelSize + 28,
                    height: wheelSize + 28,
                    child: CustomPaint(
                      painter: _DartboardWheelPainter(
                        gages: widget.gages,
                        angle: _angle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Winner card  OR  Legend grid ───────────────────────
                _winner != null
                    ? Expanded(
                        child: _WinnerSection(
                          winner: _winner!,
                          t: t,
                          l10n: l10n,
                          onDismiss: widget.onDismiss,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: _LegendGrid(
                          gages: widget.gages,
                          spinning: isSpinning,
                        ),
                      ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Winner section ────────────────────────────────────────────────────────────

class _WinnerSection extends StatelessWidget {
  final Gage winner;
  final dynamic t;
  final AppLocalizations l10n;
  final VoidCallback onDismiss;

  const _WinnerSection({
    required this.winner,
    required this.t,
    required this.l10n,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(winner.emoji, style: const TextStyle(fontSize: 52)),
        const SizedBox(height: 14),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20)
            ],
          ),
          child: Text(
            winner.text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: t.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onDismiss,
              child: Text(
                l10n.continueGame,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Legend grid ───────────────────────────────────────────────────────────────

class _LegendGrid extends StatelessWidget {
  final List<Gage> gages;
  final bool spinning;

  const _LegendGrid({required this.gages, required this.spinning});

  @override
  Widget build(BuildContext context) {
    if (spinning) return const SizedBox.shrink();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 4,
      ),
      itemCount: gages.length,
      itemBuilder: (context, i) {
        final gage = gages[i];
        final dotColor = i % 2 == 0 ? _kDartRed : _kDartGreen;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.10), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Text(gage.emoji, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  gage.text,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70), fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Dartboard wheel painter ───────────────────────────────────────────────────

class _DartboardWheelPainter extends CustomPainter {
  final List<Gage> gages;
  final double angle;

  const _DartboardWheelPainter({required this.gages, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final n = gages.length;
    if (n == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerR = (size.width / 2) - 10;
    final bodyR = outerR * 0.80; // ring = outer 20%
    final segRad = (2 * pi) / n;
    const startOff = -pi / 2;

    // ── Rotating part ────────────────────────────────────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * pi / 180);

    // 1. Outer ring wedges (alternating red / green)
    for (int i = 0; i < n; i++) {
      final s = startOff + i * segRad;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: outerR),
        s, segRad, true,
        Paint()..color = i % 2 == 0 ? _kDartRed : _kDartGreen,
      );
    }

    // 2. Body wedges (alternating black / cream) — drawn on top to reveal ring
    for (int i = 0; i < n; i++) {
      final s = startOff + i * segRad;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: bodyR),
        s, segRad, true,
        Paint()..color = i % 2 == 0 ? _kDartBlack : _kDartCream,
      );
    }

    // 3. Divider lines (center → outer edge)
    final divPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < n; i++) {
      final a = startOff + i * segRad;
      canvas.drawLine(
        Offset.zero,
        Offset(cos(a) * outerR, sin(a) * outerR),
        divPaint,
      );
    }

    // Ring / body border circles
    canvas.drawCircle(
      Offset.zero, outerR,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      Offset.zero, bodyR,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 4. Numbers in outer ring (white, radially rotated)
    final numR = bodyR + (outerR - bodyR) * 0.5;
    final numSize = ((outerR - bodyR) * 0.55).clamp(9.0, 16.0);
    for (int i = 0; i < n; i++) {
      final mid = startOff + i * segRad + segRad / 2;
      final pos = Offset(cos(mid) * numR, sin(mid) * numR);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(mid + pi / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: numSize,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // 5. Emoji in body (scaled to fit segment)
    final emojiFontSize = (bodyR * pi / (n * 1.8)).clamp(10.0, 26.0);
    final emojiR = bodyR * 0.52;
    for (int i = 0; i < n; i++) {
      final mid = startOff + i * segRad + segRad / 2;
      final pos = Offset(cos(mid) * emojiR, sin(mid) * emojiR);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(mid + pi / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: gages[i].emoji,
          style: TextStyle(fontSize: emojiFontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // 6. Bullseye center
    canvas.drawCircle(
        Offset.zero, bodyR * 0.11, Paint()..color = _kBullGreen);
    canvas.drawCircle(
        Offset.zero, bodyR * 0.06, Paint()..color = _kBullRed);
    canvas.drawCircle(
        Offset.zero,
        bodyR * 0.025,
        Paint()..color = Colors.white.withValues(alpha: 0.9));

    canvas.restore();

    // ── Fixed decorations ────────────────────────────────────────────────────

    // Outer frame
    canvas.drawCircle(
      center,
      outerR + 5,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Pointer triangle (fixed, points down into wheel at top)
    final tipY = center.dy - outerR - 1;
    final baseY = center.dy - outerR + 18;
    final ptr = Path()
      ..moveTo(center.dx - 11, baseY)
      ..lineTo(center.dx + 11, baseY)
      ..lineTo(center.dx, tipY)
      ..close();
    canvas.drawPath(ptr, Paint()..color = Colors.white);
    canvas.drawPath(
      ptr,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_DartboardWheelPainter old) =>
      old.angle != angle || old.gages != gages;
}
