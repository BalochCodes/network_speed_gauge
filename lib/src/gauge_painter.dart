import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'gauge_theme.dart';

/// Custom painter that renders the circular speedometer arc, neon glow,
/// radial tick marks, and dynamic needle pointer.
class GaugePainter extends CustomPainter {
  /// Normalized speed fraction from 0.0 to 1.0.
  final double normalizedValue;

  /// Sweep angle of the gauge in degrees (e.g. 240.0).
  final double sweepAngleDegrees;

  /// The active theme configuration.
  final GaugeTheme theme;

  /// Creates a [GaugePainter].
  const GaugePainter({
    required this.normalizedValue,
    required this.sweepAngleDegrees,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - theme.arcThickness - 16) / 2;
    if (radius <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Calculate arc angles (centered with opening at bottom)
    final sweepAngleRad = (sweepAngleDegrees * math.pi) / 180.0;
    final startAngleRad = ((90.0 + (360.0 - sweepAngleDegrees) / 2) * math.pi) / 180.0;

    // 1. Draw inactive background track
    final trackPaint = Paint()
      ..color = theme.trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = theme.arcThickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngleRad, sweepAngleRad, false, trackPaint);

    // 2. Draw radial tick marks
    if (theme.showTicks) {
      _drawTicks(canvas, center, radius, startAngleRad, sweepAngleRad);
    }

    // 3. Draw active speed arc with neon glow
    final clampedFraction = normalizedValue.clamp(0.0, 1.0);
    final activeSweepRad = sweepAngleRad * clampedFraction;

    if (activeSweepRad > 0.005) {
      final gradient = SweepGradient(
        startAngle: startAngleRad,
        endAngle: startAngleRad + sweepAngleRad,
        colors: theme.speedGradientColors,
        stops: theme.gradientStops,
        transform: GradientRotation(0.0),
      );

      // Neon outer glow blur
      if (theme.glowRadius > 0) {
        final glowPaint = Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = theme.arcThickness * 1.3
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, theme.glowRadius);

        canvas.drawArc(rect, startAngleRad, activeSweepRad, false, glowPaint);
      }

      // Foreground crisp active arc
      final activePaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = theme.arcThickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngleRad, activeSweepRad, false, activePaint);
    }

    // 4. Draw dynamic pointer needle
    _drawNeedle(canvas, center, radius, startAngleRad, sweepAngleRad, clampedFraction);
  }

  void _drawTicks(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngleRad,
    double sweepAngleRad,
  ) {
    final totalIntervals = theme.majorTickCount - 1;
    if (totalIntervals <= 0) return;

    final tickInnerBase = radius - (theme.arcThickness / 2) - 8;

    for (int i = 0; i < theme.majorTickCount; i++) {
      final majorProgress = i / totalIntervals;
      final majorAngle = startAngleRad + (majorProgress * sweepAngleRad);

      // Draw major tick
      final p1 = center + Offset(math.cos(majorAngle), math.sin(majorAngle)) * tickInnerBase;
      final p2 = center + Offset(math.cos(majorAngle), math.sin(majorAngle)) * (tickInnerBase - 8);

      final majorPaint = Paint()
        ..color = theme.majorTickColor
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, majorPaint);

      // Draw minor ticks within interval
      if (i < totalIntervals && theme.minorTicksPerInterval > 0) {
        final step = sweepAngleRad / (totalIntervals * (theme.minorTicksPerInterval + 1));
        for (int m = 1; m <= theme.minorTicksPerInterval; m++) {
          final minorAngle = majorAngle + (step * m);
          final m1 = center + Offset(math.cos(minorAngle), math.sin(minorAngle)) * tickInnerBase;
          final m2 = center + Offset(math.cos(minorAngle), math.sin(minorAngle)) * (tickInnerBase - 4);

          final minorPaint = Paint()
            ..color = theme.minorTickColor
            ..strokeWidth = 1.0;

          canvas.drawLine(m1, m2, minorPaint);
        }
      }
    }
  }

  void _drawNeedle(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngleRad,
    double sweepAngleRad,
    double fraction,
  ) {
    final needleAngle = startAngleRad + (fraction * sweepAngleRad);
    final needleLength = radius * theme.needleLengthFactor;
    final perpAngle = needleAngle + (math.pi / 2);

    final tip = center + Offset(math.cos(needleAngle), math.sin(needleAngle)) * needleLength;
    final baseOffset = 3.5;
    final backOffset = 10.0;

    final leftBase = center +
        Offset(math.cos(perpAngle), math.sin(perpAngle)) * baseOffset -
        Offset(math.cos(needleAngle), math.sin(needleAngle)) * backOffset;

    final rightBase = center -
        Offset(math.cos(perpAngle), math.sin(perpAngle)) * baseOffset -
        Offset(math.cos(needleAngle), math.sin(needleAngle)) * backOffset;

    final needlePath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(leftBase.dx, leftBase.dy)
      ..lineTo(rightBase.dx, rightBase.dy)
      ..close();

    // Needle shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(needlePath.shift(const Offset(2, 3)), shadowPaint);

    // Needle body
    final needlePaint = Paint()
      ..color = theme.needleColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(needlePath, needlePaint);

    // Central pivot
    final pivotPaint = Paint()
      ..color = theme.pivotColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, theme.pivotRadius, pivotPaint);

    final pivotRingPaint = Paint()
      ..color = theme.needleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, theme.pivotRadius, pivotRingPaint);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.normalizedValue != normalizedValue ||
        oldDelegate.sweepAngleDegrees != sweepAngleDegrees ||
        oldDelegate.theme != theme;
  }
}
