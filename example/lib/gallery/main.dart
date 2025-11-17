import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'navigation/example_gallery.dart';

void main() {
  runApp(const SketchyExamplesApp());
}

class SketchyExamplesApp extends StatefulWidget {
  const SketchyExamplesApp({super.key});

  @override
  State<SketchyExamplesApp> createState() => _SketchyExamplesAppState();
}

class _SketchyExamplesAppState extends State<SketchyExamplesApp> {
  SketchyColorMode _mode = SketchyColorMode.blue;
  double _roughness = 0.5;

  void _cycleMode() {
    const modes = SketchyColorMode.values;
    final current = modes.indexOf(_mode);
    setState(() => _mode = modes[(current + 1) % modes.length]);
  }

  void _handleRoughness(double value) {
    setState(() => _roughness = value.clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Sketchy Examples',
    theme: SketchyThemeData.fromMode(_mode, roughness: _roughness),
    debugShowCheckedModeBanner: false,
    home: ExampleGallery(
      onCycleMode: _cycleMode,
      roughness: _roughness,
      onRoughnessChanged: _handleRoughness,
    ),
  );
}
