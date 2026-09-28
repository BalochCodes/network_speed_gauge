/// Supported unit scales for network speed measurement.
enum SpeedUnit {
  /// Kilobits per second (Kbps).
  kbps,

  /// Megabits per second (Mbps).
  mbps,

  /// Gigabits per second (Gbps).
  gbps,

  /// Automatically selects the best unit based on the current value.
  auto,
}

/// Holds the formatted display value and unit label.
class FormattedSpeed {
  /// The numeric value scaled to the appropriate unit.
  final double value;

  /// The unit string label (e.g., 'Kbps', 'Mbps', 'Gbps').
  final String unit;

  /// Creates a [FormattedSpeed] instance.
  const FormattedSpeed({
    required this.value,
    required this.unit,
  });

  /// Formatted string representation (e.g. "84.5 Mbps").
  String format([int decimals = 1]) {
    return '${value.toStringAsFixed(decimals)} $unit';
  }

  @override
  String toString() => format();
}

/// Helper utility for scaling and formatting raw Mbps bandwidth values.
class SpeedUnitFormatter {
  /// Converts a bandwidth value in Mbps to the target [SpeedUnit].
  static FormattedSpeed format(
    double valueInMbps, {
    SpeedUnit unit = SpeedUnit.auto,
  }) {
    if (valueInMbps < 0) valueInMbps = 0.0;

    switch (unit) {
      case SpeedUnit.kbps:
        return FormattedSpeed(value: valueInMbps * 1000.0, unit: 'Kbps');
      case SpeedUnit.mbps:
        return FormattedSpeed(value: valueInMbps, unit: 'Mbps');
      case SpeedUnit.gbps:
        return FormattedSpeed(value: valueInMbps / 1000.0, unit: 'Gbps');
      case SpeedUnit.auto:
        if (valueInMbps < 1.0 && valueInMbps > 0.0) {
          return FormattedSpeed(value: valueInMbps * 1000.0, unit: 'Kbps');
        } else if (valueInMbps >= 1000.0) {
          return FormattedSpeed(value: valueInMbps / 1000.0, unit: 'Gbps');
        } else {
          return FormattedSpeed(value: valueInMbps, unit: 'Mbps');
        }
    }
  }
}
