import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

Map<String, String> get fontOptions => <String, String>{
  'Comic Shanns': 'ComicShanns',
  'Excalifont': 'Excalifont',
  'xkcd': 'XKCD',
  'Gloria Hallelujah':
      GoogleFonts.gloriaHallelujah().fontFamily ?? 'ComicShanns',
};

SketchyThemeData resolveSketchyTheme({
  required SketchyThemes theme,
  required double roughness,
  required String fontFamily,
  required TextCase textCase,
  required SketchyThemeMode mode,
}) {
  // Determine brightness based on the app mode setting Note: In a real app,
  // 'system' would check MediaQuery, but here we simulate.
  final brightness = mode == SketchyThemeMode.dark
      ? Brightness.dark
      : Brightness.light;

  final data = SketchyThemeData.fromTheme(
    theme,
    brightness: brightness,
    roughness: roughness,
    textCase: textCase,
  );

  return data.copyWith(
    typography: data.typography.copyWith(
      headline: data.typography.headline.copyWith(fontFamily: fontFamily),
      title: data.typography.title.copyWith(fontFamily: fontFamily),
      body: data.typography.body.copyWith(fontFamily: fontFamily),
      caption: data.typography.caption.copyWith(fontFamily: fontFamily),
      label: data.typography.label.copyWith(fontFamily: fontFamily),
    ),
  );
}

String textCaseLabel(TextCase casing) {
  switch (casing) {
    case TextCase.none:
      return 'None';
    case TextCase.allCaps:
      return 'All Caps';
    case TextCase.titleCase:
      return 'Title Case';
    case TextCase.allLower:
      return 'All Lower';
  }
}
