import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_speed_gauge/network_speed_gauge.dart';

void main() {
  group('NetworkSpeedGauge Widget Tests', () {
    testWidgets('renders speedometer dial with digital value display', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: NetworkSpeedGauge(
                value: 85.5,
                maxValue: 200.0,
              ),
            ),
          ),
        ),
      );

      // Verify CustomPaint gauge exists
      expect(find.byType(CustomPaint), findsWidgets);

      // Settle animation
      await tester.pumpAndSettle();

      // Verify digital readout
      expect(find.text('85.5'), findsOneWidget);
      expect(find.text('Mbps'), findsOneWidget);
    });

    testWidgets('renders SubMetricsBar when metrics are provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: NetworkSpeedGauge(
                value: 120.0,
                subMetrics: GaugeSubMetrics(
                  downloadMbps: 120.0,
                  uploadMbps: 45.0,
                  pingMs: 15.0,
                  jitterMs: 2.0,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SubMetricsBar), findsOneWidget);
      expect(find.text('DOWNLOAD'), findsOneWidget);
      expect(find.text('UPLOAD'), findsOneWidget);
      expect(find.text('PING'), findsOneWidget);
      expect(find.text('JITTER'), findsOneWidget);
      expect(find.text('15 ms'), findsOneWidget);
    });

    testWidgets('hides digital readout when showDigitalDisplay is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: NetworkSpeedGauge(
                value: 50.0,
                showDigitalDisplay: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('50.0'), findsNothing);
      expect(find.text('Mbps'), findsNothing);
    });
  });
}
