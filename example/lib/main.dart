import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:network_speed_gauge/network_speed_gauge.dart';

void main() {
  runApp(const SpeedGaugeDemoApp());
}

class SpeedGaugeDemoApp extends StatelessWidget {
  const SpeedGaugeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Speed Gauge Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
      ),
      home: const SpeedGaugeHomePage(),
    );
  }
}

class SpeedGaugeHomePage extends StatefulWidget {
  const SpeedGaugeHomePage({super.key});

  @override
  State<SpeedGaugeHomePage> createState() => _SpeedGaugeHomePageState();
}

class _SpeedGaugeHomePageState extends State<SpeedGaugeHomePage> {
  double _currentSpeed = 0.0;
  bool _isTesting = false;
  Timer? _testTimer;
  int _themeIndex = 0;

  GaugeSubMetrics _metrics = const GaugeSubMetrics(
    pingMs: 14.0,
    jitterMs: 2.0,
  );

  final List<GaugeTheme> _themes = [
    const GaugeTheme(), // Neon Cyan/Green/Amber/Crimson
    GaugeTheme.cyberpunk(),
    GaugeTheme.matrixGreen(),
    GaugeTheme.minimalLight(),
  ];

  final List<String> _themeNames = [
    'Electric Neon',
    'Cyberpunk',
    'Matrix Emerald',
    'Minimal Light',
  ];

  @override
  void dispose() {
    _testTimer?.cancel();
    super.dispose();
  }

  void _startSpeedTest() {
    if (_isTesting) {
      _stopSpeedTest();
      return;
    }

    setState(() {
      _isTesting = true;
      _currentSpeed = 5.0;
      _metrics = const GaugeSubMetrics(pingMs: 12.0, jitterMs: 1.8);
    });

    final random = math.Random();
    int tick = 0;

    _testTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      tick++;

      if (tick < 15) {
        // Ramp up stage (0 - 150 Mbps)
        final ramp = tick * 12.0 + (random.nextDouble() * 15.0);
        setState(() {
          _currentSpeed = ramp;
          _metrics = GaugeSubMetrics(
            downloadMbps: ramp,
            pingMs: 11.0 + random.nextDouble() * 3.0,
            jitterMs: 1.5 + random.nextDouble(),
          );
        });
      } else if (tick < 35) {
        // Fluctuating peak plateau (180 - 245 Mbps)
        final fluctuation = 210.0 + ((random.nextDouble() - 0.5) * 45.0);
        setState(() {
          _currentSpeed = fluctuation;
          _metrics = GaugeSubMetrics(
            downloadMbps: 215.4,
            uploadMbps: (tick > 25) ? (tick - 25) * 8.0 : null,
            pingMs: 12.0,
            jitterMs: 1.9,
          );
        });
      } else if (tick < 45) {
        // Upload phase
        final uploadSpeed = 75.0 + ((random.nextDouble() - 0.5) * 20.0);
        setState(() {
          _currentSpeed = uploadSpeed;
          _metrics = GaugeSubMetrics(
            downloadMbps: 218.6,
            uploadMbps: uploadSpeed,
            pingMs: 12.0,
            jitterMs: 2.1,
          );
        });
      } else {
        // Completed
        _stopSpeedTest();
        setState(() {
          _currentSpeed = 0.0;
          _metrics = const GaugeSubMetrics(
            downloadMbps: 224.8,
            uploadMbps: 84.2,
            pingMs: 12.0,
            jitterMs: 1.9,
          );
        });
      }
    });
  }

  void _stopSpeedTest() {
    _testTimer?.cancel();
    setState(() {
      _isTesting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = _themes[_themeIndex];
    final isLight = _themeIndex == 3;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0B0F17),
      appBar: AppBar(
        title: Text(
          'Network Speed Gauge',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLight ? const Color(0xFF0F172A) : Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.palette_outlined,
              color: isLight ? Colors.black87 : Colors.white70,
            ),
            tooltip: 'Switch Theme',
            onPressed: () {
              setState(() {
                _themeIndex = (_themeIndex + 1) % _themes.length;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Theme Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isLight
                    ? Colors.grey.shade200
                    : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Theme: ${_themeNames[_themeIndex]}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isLight ? Colors.black87 : const Color(0xFF94A3B8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Speedometer Gauge
            NetworkSpeedGauge(
              value: _currentSpeed,
              maxValue: 300.0,
              size: 280.0,
              theme: activeTheme,
              subMetrics: _metrics,
              animationDuration: const Duration(milliseconds: 220),
              animationCurve: Curves.easeOutBack,
            ),

            const SizedBox(height: 36),

            // Action Test Button
            SizedBox(
              width: 220,
              height: 52,
              child: ElevatedButton(
                onPressed: _startSpeedTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTesting
                      ? const Color(0xFFEF4444)
                      : activeTheme.needleColor,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isTesting ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isTesting ? 'STOP TEST' : 'START TEST',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Manual Slider for testing arbitrary speeds
            if (!_isTesting) ...[
              Text(
                'Or drag to test custom speed:',
                style: TextStyle(
                  fontSize: 13,
                  color: isLight ? Colors.black54 : const Color(0xFF64748B),
                ),
              ),
              Slider(
                value: _currentSpeed,
                min: 0.0,
                max: 300.0,
                activeColor: activeTheme.needleColor,
                onChanged: (val) {
                  setState(() {
                    _currentSpeed = val;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
