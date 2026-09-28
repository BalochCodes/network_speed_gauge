import 'package:flutter_test/flutter_test.dart';
import 'package:network_speed_gauge/network_speed_gauge.dart';

void main() {
  group('SpeedUnitFormatter Tests', () {
    test('auto scale converts < 1.0 Mbps to Kbps', () {
      final formatted = SpeedUnitFormatter.format(0.75, unit: SpeedUnit.auto);
      expect(formatted.value, closeTo(750.0, 0.01));
      expect(formatted.unit, 'Kbps');
      expect(formatted.format(0), '750 Kbps');
    });

    test('auto scale keeps standard bandwidth as Mbps', () {
      final formatted = SpeedUnitFormatter.format(84.2, unit: SpeedUnit.auto);
      expect(formatted.value, closeTo(84.2, 0.01));
      expect(formatted.unit, 'Mbps');
      expect(formatted.format(1), '84.2 Mbps');
    });

    test('auto scale converts >= 1000 Mbps to Gbps', () {
      final formatted = SpeedUnitFormatter.format(2400.0, unit: SpeedUnit.auto);
      expect(formatted.value, closeTo(2.4, 0.01));
      expect(formatted.unit, 'Gbps');
      expect(formatted.format(1), '2.4 Gbps');
    });

    test('explicit unit converts correctly', () {
      final kbps = SpeedUnitFormatter.format(5.0, unit: SpeedUnit.kbps);
      expect(kbps.value, 5000.0);
      expect(kbps.unit, 'Kbps');

      final gbps = SpeedUnitFormatter.format(500.0, unit: SpeedUnit.gbps);
      expect(gbps.value, 0.5);
      expect(gbps.unit, 'Gbps');
    });

    test('negative bandwidth clamps to 0', () {
      final formatted = SpeedUnitFormatter.format(-25.0);
      expect(formatted.value, 0.0);
    });
  });
}
