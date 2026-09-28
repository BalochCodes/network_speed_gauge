# network_speed_gauge

[![pub package](https://img.shields.io/pub/v/network_speed_gauge.svg?logo=dart&logoColor=white&style=flat-square)](https://pub.dev/packages/network_speed_gauge)
[![Pub Points](https://img.shields.io/badge/pub%20points-160%2F160-blue?style=flat-square)](https://pub.dev/packages/network_speed_gauge/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Likes](https://img.shields.io/pub/likes/network_speed_gauge?logo=dart&logoColor=white&style=flat-square)](https://pub.dev/packages/network_speed_gauge)

A futuristic circular speedometer dial and bandwidth meter widget for Flutter with glowing neon speed arcs, spring needle physics, digital readouts, and auto unit scaling.

---

## 🌟 Overview & Hook

Most network utilities, VPN clients, and speed test apps rely on crude linear progress bars or sluggish charting libraries that feel lifeless and heavy.

**network_speed_gauge** delivers a responsive, cyberpunk-inspired speedometer dial:
- Built with high-performance `CustomPainter` and **zero heavy external dependencies**.
- Features realistic spring / elastic damping needle physics responding dynamically to live bandwidth fluctuations.
- Glowing neon multi-threshold speed arcs (Low / Med / High / Ultra-fast) with customizable gradient sweeps.
- Integrated digital speed counter with auto-scaling unit formatting (`Kbps`, `Mbps`, `Gbps`) and secondary diagnostics (Download, Upload, Ping, Jitter).

---

## ✨ Features

- 🏎️ **Dynamic Needle Physics:** Realistic spring damping bounce (`Curves.easeOutBack`) accurately mimics physical dial needles.
- ⚡ **Neon Multi-Threshold Arcs:** Multi-color gradient sweeps with outer blur glows for an eye-catching HUD look.
- 🔄 **Smart Unit Scaling:** Automatically scales bandwidth readouts between Kbps, Mbps, and Gbps based on thresholds.
- 📊 **Secondary Metrics HUD:** Dedicated diagnostics bar for Download, Upload, Ping, and Jitter.
- 🎨 **Pre-Built Themes:** Includes Cyberpunk Neon, Matrix Emerald, Electric Blue, and Minimal Clean Daylight presets.
- 📐 **Configurable Geometry:** Freely adjust sweep angle (180° semi-circle, 240° speedometer arch, 270° performance dial), tick marks, and needle sizing.
- 🚀 **Zero Dependencies:** Pure Flutter rendering that easily achieves 60/120 FPS on iOS, Android, macOS, Web, and Windows.

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```bash
flutter pub add network_speed_gauge
```

Or manually:

```yaml
dependencies:
  network_speed_gauge: ^0.0.1
```

Then import:

```dart
import 'package:network_speed_gauge/network_speed_gauge.dart';
```

---

## ⚡ Quick Start

Set up a working speedometer gauge in under 20 lines of code:

```dart
import 'package:flutter/material.dart';
import 'package:network_speed_gauge/network_speed_gauge.dart';

class SpeedTestWidget extends StatelessWidget {
  const SpeedTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B0F17),
      body: Center(
        child: NetworkSpeedGauge(
          value: 145.8,
          maxValue: 300.0,
          theme: GaugeTheme(),
        ),
      ),
    );
  }
}
```

---

## 📖 Advanced Usage & Examples

### 1. Cyberpunk Theme with Sub-Metrics (Download, Upload, Ping, Jitter)

```dart
NetworkSpeedGauge(
  value: 284.5,
  maxValue: 500.0,
  size: 300.0,
  theme: GaugeTheme.cyberpunk(),
  subMetrics: const GaugeSubMetrics(
    downloadMbps: 284.5,
    uploadMbps: 92.1,
    pingMs: 11.0,
    jitterMs: 1.4,
  ),
  animationDuration: const Duration(milliseconds: 250),
)
```

### 2. Matrix Green Semi-Circle (180° Arc)

```dart
NetworkSpeedGauge(
  value: 75.0,
  maxValue: 100.0,
  sweepAngle: 180.0,
  theme: GaugeTheme.matrixGreen(),
)
```

---

## 🛠️ Properties Table

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `double` | *Required* | Current measured speed value in Mbps. |
| `maxValue` | `double` | `100.0` | Maximum capacity scale displayed on the dial. |
| `unit` | `SpeedUnit` | `SpeedUnit.auto` | Unit scaling mode (`auto`, `kbps`, `mbps`, `gbps`). |
| `sweepAngle` | `double` | `240.0` | Angular arc sweep in degrees (e.g. 180°, 240°, 270°). |
| `size` | `double` | `260.0` | Overall diameter / size of the circular gauge. |
| `theme` | `GaugeTheme` | `GaugeTheme()` | Visual colors, neon glow, tick marks, and needle styling. |
| `subMetrics` | `GaugeSubMetrics?` | `null` | Optional diagnostics (Download, Upload, Ping, Jitter). |
| `animate` | `bool` | `true` | Whether to animate value changes. |
| `animationDuration` | `Duration` | `500ms` | Duration for needle and value transitions. |
| `animationCurve` | `Curve` | `Curves.easeOutBack` | Curve for spring needle damping physics. |
| `showDigitalDisplay` | `bool` | `true` | Whether to render central numeric readout and unit. |

---

## 🎬 Preview & Demo

```
+-------------------------------------------------------------+
|                     [ network_speed_gauge ]                 |
|                                                             |
|                         . - ~ - .                           |
|                     . '     |     ' .                       |
|                   /         |         \                     |
|                  |     -->  /          |                    |
|                  |       245.8         |                    |
|                   \       Mbps        /                     |
|                     ' .             '                       |
|                         ' - - - '                           |
|      [ DOWNLOAD: 245M | UPLOAD: 84M | PING: 12ms | JITTER: 2ms ]|
+-------------------------------------------------------------+
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to open an issue or pull request on [GitHub](https://github.com/BalochCodes/network_speed_gauge).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Developed with ❤️ by **Shahzain Baloch** ([BalochCodes](https://github.com/BalochCodes)).
