import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() => runApp(const HelloSketchyApp());

class HelloSketchyApp extends StatelessWidget {
  const HelloSketchyApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Hello Sketchy',
    theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
    home: const Center(
      child: SketchyFrame(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SketchyText('Hello, Sketchy!'),
        ),
      ),
    ),
  );
}
