import 'package:flutter/material.dart';
import 'gauge_metrics.dart';
import 'gauge_painter.dart';
import 'gauge_theme.dart';
import 'speed_unit.dart';

/// A futuristic circular speedometer dial and bandwidth gauge for Flutter.
///
/// Features dynamic needle pointer with spring damping physics, multi-threshold
/// neon speed arcs, glowing shadows, central digital readout, and secondary metrics.
class NetworkSpeedGauge extends StatefulWidget {
  /// The measured bandwidth speed in Mbps.
  final double value;

  /// The maximum capacity limit displayed on the gauge (in Mbps). Defaults to 100.0.
  final double maxValue;

  /// The unit formatting mode (auto, kbps, mbps, gbps). Defaults to [SpeedUnit.auto].
  final SpeedUnit unit;

  /// Angular sweep of the speedometer arc in degrees. Defaults to 240.0.
  final double sweepAngle;

  /// Overall diameter/size of the circular gauge widget. Defaults to 260.0.
  final double size;

  /// Visual theme configuration. Defaults to [GaugeTheme].
  final GaugeTheme theme;

  /// Optional secondary network metrics (Download, Upload, Ping, Jitter).
  final GaugeSubMetrics? subMetrics;

  /// Whether to animate value changes with spring physics. Defaults to true.
  final bool animate;

  /// Duration of the needle and value transition animation. Defaults to 500ms.
  final Duration animationDuration;

  /// Animation curve for the needle transition.
  /// Defaults to [Curves.easeOutBack] for realistic spring damping bounce.
  final Curve animationCurve;

  /// Whether to display the central digital speed readout and unit. Defaults to true.
  final bool showDigitalDisplay;

  /// Creates a [NetworkSpeedGauge].
  const NetworkSpeedGauge({
    super.key,
    required this.value,
    this.maxValue = 100.0,
    this.unit = SpeedUnit.auto,
    this.sweepAngle = 240.0,
    this.size = 260.0,
    this.theme = const GaugeTheme(),
    this.subMetrics,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeOutBack,
    this.showDigitalDisplay = true,
  }) : assert(maxValue > 0, 'maxValue must be greater than 0');

  @override
  State<NetworkSpeedGauge> createState() => _NetworkSpeedGaugeState();
}

class _NetworkSpeedGaugeState extends State<NetworkSpeedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _valueAnimation = Tween<double>(
      begin: widget.animate ? 0.0 : widget.value,
      end: widget.value,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant NetworkSpeedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.animate) {
        _valueAnimation = Tween<double>(
          begin: _currentValue,
          end: widget.value,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.animationCurve,
          ),
        );
        _controller.forward(from: 0.0);
      } else {
        setState(() {
          _currentValue = widget.value;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _valueAnimation,
          builder: (context, child) {
            final animatedValue = widget.animate ? _valueAnimation.value : _currentValue;
            _currentValue = animatedValue;

            final normalizedProgress = (animatedValue / widget.maxValue).clamp(0.0, 1.0);
            final formatted = SpeedUnitFormatter.format(animatedValue, unit: widget.unit);

            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Gauge dial and dynamic needle
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: GaugePainter(
                      normalizedValue: normalizedProgress,
                      sweepAngleDegrees: widget.sweepAngle,
                      theme: widget.theme,
                    ),
                  ),

                  // Central Digital Speed Readout
                  if (widget.showDigitalDisplay)
                    Positioned(
                      bottom: widget.size * 0.22,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatted.value.toStringAsFixed(1),
                            style: widget.theme.valueTextStyle ??
                                const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.0,
                                  fontFamily: 'monospace',
                                ),
                          ),
                          Text(
                            formatted.unit,
                            style: widget.theme.unitTextStyle ??
                                TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: widget.theme.needleColor,
                                  letterSpacing: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        // Sub-metrics HUD bar
        if (widget.subMetrics != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.size * 1.25),
            child: SubMetricsBar(metrics: widget.subMetrics!),
          ),
        ],
      ],
    );
  }
}
