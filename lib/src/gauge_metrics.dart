import 'package:flutter/material.dart';

/// Represents secondary diagnostic metrics for a network connection test.
class GaugeSubMetrics {
  /// Measured download speed in Mbps.
  final double? downloadMbps;

  /// Measured upload speed in Mbps.
  final double? uploadMbps;

  /// Round-trip ping latency in milliseconds.
  final double? pingMs;

  /// Latency jitter variation in milliseconds.
  final double? jitterMs;

  /// Creates a [GaugeSubMetrics] container.
  const GaugeSubMetrics({
    this.downloadMbps,
    this.uploadMbps,
    this.pingMs,
    this.jitterMs,
  });
}

/// A compact HUD metrics bar displaying Download, Upload, Ping, and Jitter.
class SubMetricsBar extends StatelessWidget {
  /// The network test metrics to render.
  final GaugeSubMetrics metrics;

  /// Background color of the container card.
  final Color backgroundColor;

  /// Border color of the container card.
  final Color borderColor;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Value text style.
  final TextStyle? valueStyle;

  /// Creates a [SubMetricsBar].
  const SubMetricsBar({
    super.key,
    required this.metrics,
    this.backgroundColor = const Color(0xFF131A26),
    this.borderColor = const Color(0xFF1E293B),
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
              icon: Icons.arrow_downward_rounded,
              iconColor: const Color(0xFF00E5FF),
              label: 'DOWNLOAD',
              value: metrics.downloadMbps != null
                  ? '${metrics.downloadMbps!.toStringAsFixed(1)} M'
                  : '--',
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              icon: Icons.arrow_upward_rounded,
              iconColor: const Color(0xFF8B5CF6),
              label: 'UPLOAD',
              value: metrics.uploadMbps != null
                  ? '${metrics.uploadMbps!.toStringAsFixed(1)} M'
                  : '--',
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              icon: Icons.network_ping_rounded,
              iconColor: const Color(0xFF10B981),
              label: 'PING',
              value: metrics.pingMs != null
                  ? '${metrics.pingMs!.toInt()} ms'
                  : '--',
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              icon: Icons.waves_rounded,
              iconColor: const Color(0xFFF59E0B),
              label: 'JITTER',
              value: metrics.jitterMs != null
                  ? '${metrics.jitterMs!.toInt()} ms'
                  : '--',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: borderColor,
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 3),
              Text(
                label,
                style: labelStyle ??
                    const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
