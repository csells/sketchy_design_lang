import 'dart:ui';

import 'sketchy_colors.dart';

/// Supported Sketchy theme presets.
enum SketchyThemes {
  /// Classic monochrome look (black ink on white paper).
  monochrome,

  /// Bold scarlet-inspired theme.
  red,

  /// Energetic orange theme.
  orange,

  /// Bright yellow theme.
  yellow,

  /// Fresh green theme.
  green,

  /// Playful cyan theme.
  cyan,

  /// Default blue theme.
  blue,

  /// Deep indigo theme.
  indigo,

  /// Vivid violet theme.
  violet,

  /// Punchy magenta theme.
  magenta,
}

/// Extension mapping themes to their core color palette.
extension SketchyThemePalette on SketchyThemes {
  /// Returns the tuple of (ink, paper, primary, secondary) colors for this theme.
  (Color, Color, Color, Color) get palette => switch (this) {
    SketchyThemes.monochrome => (
      SketchyColors.black,
      SketchyColors.white,
      SketchyColors.black,
      SketchyColors.ash,
    ),
    SketchyThemes.red => (
      SketchyColors.maroon,
      SketchyColors.blush,
      SketchyColors.scarlet,
      SketchyColors.lightCoral,
    ),
    SketchyThemes.orange => (
      SketchyColors.rust,
      SketchyColors.apricot,
      SketchyColors.ember,
      SketchyColors.peach,
    ),
    SketchyThemes.yellow => (
      SketchyColors.ochre,
      SketchyColors.cream,
      SketchyColors.lemon,
      SketchyColors.lightLemon,
    ),
    SketchyThemes.green => (
      SketchyColors.forestGreen,
      SketchyColors.mint,
      SketchyColors.lime,
      SketchyColors.lightSage,
    ),
    SketchyThemes.cyan => (
      SketchyColors.deepTeal,
      SketchyColors.aqua,
      SketchyColors.teal,
      SketchyColors.turquoise,
    ),
    SketchyThemes.blue => (
      SketchyColors.navy,
      SketchyColors.cloud,
      SketchyColors.cobalt,
      SketchyColors.sky,
    ),
    SketchyThemes.indigo => (
      SketchyColors.midnight,
      SketchyColors.lavender,
      SketchyColors.indigo,
      SketchyColors.periwinkle,
    ),
    SketchyThemes.violet => (
      SketchyColors.plum,
      SketchyColors.orchid,
      SketchyColors.violet,
      SketchyColors.lilac,
    ),
    SketchyThemes.magenta => (
      SketchyColors.wine,
      SketchyColors.rose,
      SketchyColors.magenta,
      SketchyColors.pink,
    ),
  };
}
