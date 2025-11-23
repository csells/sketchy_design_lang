import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/theme_utils.dart';
import 'sketchy_design_system_page.dart';

class SketchyDesignSystemApp extends StatefulWidget {
  const SketchyDesignSystemApp({super.key});

  @override
  State<SketchyDesignSystemApp> createState() => _SketchyDesignSystemAppState();
}

class _SketchyDesignSystemAppState extends State<SketchyDesignSystemApp> {
  SketchyThemeMode _themeMode = SketchyThemeMode.system;
  SketchyThemes _activeTheme = SketchyThemes.monochrome;
  double _roughness = 0.5;
  String _fontFamily = 'ComicShanns';
  TextCase _textCase = TextCase.none;

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Sketchy Design System',
    theme: resolveSketchyTheme(
      theme: _activeTheme,
      roughness: _roughness,
      fontFamily: _fontFamily,
      textCase: _textCase,
      mode: SketchyThemeMode.light,
    ),
    themeMode: _themeMode,
    debugShowCheckedModeBanner: false,
    home: SketchyDesignSystemPage(
      activeTheme: _activeTheme,
      themeMode: _themeMode,
      roughness: _roughness,
      onThemeChanged: (theme) => setState(() => _activeTheme = theme),
      onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      onRoughnessChanged: (value) =>
          setState(() => _roughness = value.clamp(0.0, 1.0)),
      fontFamily: _fontFamily,
      onFontChanged: (family) => setState(() => _fontFamily = family),
      textCase: _textCase,
      onTitleCasingChanged: (casing) => setState(() => _textCase = casing),
    ),
  );
}
