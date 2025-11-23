import 'dart:ui';

import 'sketchy_colors.dart';

/// Supported Sketchy theme presets.
enum SketchyThemes {
  /// Classic monochrome look (black ink on white paper).
  monochrome,

  /// Bold scarlet theme.
  scarlet,

  /// Bright red theme.
  red,

  /// Energetic orange theme.
  orange,

  /// Bright yellow theme.
  yellow,

  /// Fresh green theme.
  green,

  /// Playful cyan theme.
  cyan,

  /// Dusty blue theme.
  dusty,

  /// Default blue theme.
  blue,

  /// Deep indigo theme.
  indigo,

  /// Vivid violet theme.
  violet,

  /// Pink theme.
  pink,
}

/// Extension mapping themes to their core color palette.
extension SketchyThemePalette on SketchyThemes {
  /// Returns the tuple of (ink, paper, primary, secondary) colors for this
  /// theme.
  (Color, Color, Color, Color) get palette => switch (this) {
    SketchyThemes.monochrome => (
      SketchyColors.black,
      SketchyColors.white,
      SketchyColors.black,
      SketchyColors.white,
    ),
    SketchyThemes.scarlet => (
      SketchyColors.maroon,
      SketchyColors.rose,
      SketchyColors.darkScarlet,
      SketchyColors.rosewash,
    ),
    SketchyThemes.red => (
      SketchyColors.maroon,
      SketchyColors.rose,
      SketchyColors.red,
      SketchyColors.blush,
    ),
    SketchyThemes.orange => (
      SketchyColors.rust,
      SketchyColors.apricot,
      SketchyColors.orange,
      SketchyColors.creamsicle,
    ),
    SketchyThemes.yellow => (
      SketchyColors.ochre,
      SketchyColors.cream,
      SketchyColors.yellow,
      SketchyColors.buttercream,
    ),
    SketchyThemes.green => (
      SketchyColors.forestGreen,
      SketchyColors.mint,
      SketchyColors.green,
      SketchyColors.mintFade,
    ),
    SketchyThemes.cyan => (
      SketchyColors.deepTeal,
      SketchyColors.aqua,
      SketchyColors.cyan,
      SketchyColors.iceMist,
    ),
    SketchyThemes.dusty => (
      SketchyColors.navy,
      SketchyColors.cloud,
      SketchyColors.dusty,
      SketchyColors.powderBlue,
    ),
    SketchyThemes.blue => (
      SketchyColors.navy,
      SketchyColors.cloud,
      SketchyColors.blue,
      SketchyColors.skywash,
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
      SketchyColors.lavenderHaze,
    ),
    SketchyThemes.pink => (
      SketchyColors.wine,
      SketchyColors.rose,
      SketchyColors.pink,
      SketchyColors.petalBlush,
    ),
  };
}
