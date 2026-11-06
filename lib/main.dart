import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Pre-warm fragment shaders asynchronously with zero GPU blocking I/O
  // Auto-preloads shaders on Android (Vulkan/GLES), iOS, macOS for Frame 1 instant launch
  await LiquidGlassWidgets.initialize(
    warmUpMode: GlassWarmUpMode.auto,
    enablePerformanceMonitor: false,
  );

  // 2. Wrap root app in LiquidGlassWidgets.wrap
  runApp(
    LiquidGlassWidgets.wrap(
      adaptiveQuality: true, // Auto-benchmarks device raster budget (60/120fps)
      respectSystemAccessibility: true, // Degrades gracefully on Reduce Motion / High Contrast
      brightnessResolver: Theme.maybeBrightnessOf, // Required for MaterialApp
      theme: const GlassThemeData.ios27(), // Native Apple iOS 27 paraxial-lens preset
      child: const ModernLocalSendApp(),
    ),
  );
}
