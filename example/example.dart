import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() => runApp(_HelloSketchyApp());

class _HelloSketchyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Hello Sketchy',
    home: const SketchySymbol(symbol: SketchySymbols.people),
  );
}
