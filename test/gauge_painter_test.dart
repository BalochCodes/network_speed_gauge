import 'package:flutter_test/flutter_test.dart';
import 'package:network_speed_gauge/network_speed_gauge.dart';

void main() {
  group('GaugePainter Tests', () {
    test('painter shouldRepaint returns true when value changes', () {
      const painter1 = GaugePainter(
        normalizedValue: 0.25,
        sweepAngleDegrees: 240.0,
        theme: GaugeTheme(),
      );

      const painter2 = GaugePainter(
        normalizedValue: 0.50,
        sweepAngleDegrees: 240.0,
        theme: GaugeTheme(),
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('painter shouldRepaint returns false when properties are identical', () {
      const painter1 = GaugePainter(
        normalizedValue: 0.60,
        sweepAngleDegrees: 240.0,
        theme: GaugeTheme(),
      );

      const painter2 = GaugePainter(
        normalizedValue: 0.60,
        sweepAngleDegrees: 240.0,
        theme: GaugeTheme(),
      );

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('painter shouldRepaint returns true when sweep angle changes', () {
      const painter1 = GaugePainter(
        normalizedValue: 0.5,
        sweepAngleDegrees: 180.0,
        theme: GaugeTheme(),
      );

      const painter2 = GaugePainter(
        normalizedValue: 0.5,
        sweepAngleDegrees: 240.0,
        theme: GaugeTheme(),
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });
  });
}
