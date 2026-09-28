import 'package:flutter/material.dart';

/// Visual customization settings for the [NetworkSpeedGauge].
class GaugeTheme {
  /// Thickness of the outer speed gauge arc. Defaults to 14.0.
  final double arcThickness;

  /// Background color of the inactive gauge track.
  final Color trackColor;

  /// Color stops / gradient applied along the active speed arc.
  final List<Color> speedGradientColors;

  /// Color stops along the arc (0.0 to 1.0).
  final List<double>? gradientStops;

  /// Intensity of the neon outer glow blur. Set to 0 to disable glow.
  final double glowRadius;

  /// Color of the dynamic pointer needle.
  final Color needleColor;

  /// Length factor of the needle relative to dial radius (0.0 to 1.0). Defaults to 0.75.
  final double needleLengthFactor;

  /// Radius of the central needle pivot circle. Defaults to 7.0.
  final double pivotRadius;

  /// Color of the central needle pivot.
  final Color pivotColor;

  /// Whether to render radial tick marks along the arc. Defaults to true.
  final bool showTicks;

  /// Number of major subdivision tick marks. Defaults to 6.
  final int majorTickCount;

  /// Number of minor ticks between each major tick. Defaults to 4.
  final int minorTicksPerInterval;

  /// Color of major tick marks.
  final Color majorTickColor;

  /// Color of minor tick marks.
  final Color minorTickColor;

  /// Text style for the central primary numeric speed display.
  final TextStyle? valueTextStyle;

  /// Text style for the unit label (e.g. 'Mbps').
  final TextStyle? unitTextStyle;

  /// Text style for tick labels along the gauge perimeter.
  final TextStyle? tickLabelStyle;

  /// Creates a [GaugeTheme] instance.
  const GaugeTheme({
    this.arcThickness = 14.0,
    this.trackColor = const Color(0xFF1E293B),
    this.speedGradientColors = const [
      Color(0xFF00E5FF), // Electric Cyan (Low)
      Color(0xFF00E676), // Bright Green (Med)
      Color(0xFFFFB300), // Amber Gold (High)
      Color(0xFFFF1744), // Crimson Neon (Ultra)
    ],
    this.gradientStops = const [0.0, 0.4, 0.75, 1.0],
    this.glowRadius = 12.0,
    this.needleColor = const Color(0xFF00E5FF),
    this.needleLengthFactor = 0.75,
    this.pivotRadius = 7.0,
    this.pivotColor = Colors.white,
    this.showTicks = true,
    this.majorTickCount = 6,
    this.minorTicksPerInterval = 4,
    this.majorTickColor = const Color(0xFF64748B),
    this.minorTickColor = const Color(0xFF334155),
    this.valueTextStyle,
    this.unitTextStyle,
    this.tickLabelStyle,
  });

  /// Cyberpunk futuristic aesthetic with electric violet, hot pink, and cyan.
  factory GaugeTheme.cyberpunk() {
    return const GaugeTheme(
      trackColor: Color(0xFF130E26),
      speedGradientColors: [
        Color(0xFF00F0FF),
        Color(0xFF7000FF),
        Color(0xFFFF007A),
        Color(0xFFFFEE00),
      ],
      needleColor: Color(0xFFFF007A),
      majorTickColor: Color(0xFF8B5CF6),
      minorTickColor: Color(0xFF4C1D95),
      glowRadius: 14.0,
    );
  }

  /// Matrix digital emerald aesthetic.
  factory GaugeTheme.matrixGreen() {
    return const GaugeTheme(
      trackColor: Color(0xFF062113),
      speedGradientColors: [
        Color(0xFF059669),
        Color(0xFF10B981),
        Color(0xFF34D399),
        Color(0xFF6EE7B7),
      ],
      needleColor: Color(0xFF34D399),
      majorTickColor: Color(0xFF059669),
      minorTickColor: Color(0xFF064E3B),
      glowRadius: 10.0,
    );
  }

  /// Minimal clean daylight theme.
  factory GaugeTheme.minimalLight() {
    return const GaugeTheme(
      trackColor: Color(0xFFE2E8F0),
      speedGradientColors: [
        Color(0xFF3B82F6),
        Color(0xFF10B981),
        Color(0xFFF59E0B),
        Color(0xFFEF4444),
      ],
      needleColor: Color(0xFF1E293B),
      pivotColor: Color(0xFF0F172A),
      majorTickColor: Color(0xFF94A3B8),
      minorTickColor: Color(0xFFCBD5E1),
      glowRadius: 0.0,
      valueTextStyle: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        color: Color(0xFF0F172A),
      ),
      unitTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF64748B),
      ),
    );
  }
}
