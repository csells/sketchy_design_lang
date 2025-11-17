import 'package:flutter/painting.dart';

import 'sketchy_color_mode.dart';
import 'sketchy_palette.dart';

/// Palette describing the “ink and paper” colors Sketchy components use.
class SketchyColors {
  /// Creates a palette with the provided role colors.
  const SketchyColors({
    required this.mode,
    required this.ink,
    required this.paper,
    required this.primary,
    required this.secondary,
    required this.info,
    required this.warning,
    required this.success,
  });

  /// Builds colors for the provided [mode].
  factory SketchyColors.forMode(SketchyColorMode mode) {
    final palette = _modePalettes[mode]!;
    return SketchyColors(
      mode: mode,
      ink: palette.ink,
      paper: palette.paper,
      primary: palette.primary,
      secondary: palette.secondary,
      info: SketchyPalette.info,
      warning: SketchyPalette.warning,
      success: SketchyPalette.success,
    );
  }

  /// Active color mode.
  final SketchyColorMode mode;

  /// Primary stroke color used for outlines and text.
  final Color ink;

  /// Background color emulating paper.
  final Color paper;

  /// Bold accent color for primary actions.
  final Color primary;

  /// Softer accent variant for fills.
  final Color secondary;

  /// Informational accent color.
  final Color info;

  /// Warning accent color.
  final Color warning;

  /// Success accent color.
  final Color success;

  /// Returns a copy of this palette with the provided overrides.
  SketchyColors copyWith({
    SketchyColorMode? mode,
    Color? ink,
    Color? paper,
    Color? primary,
    Color? secondary,
    Color? info,
    Color? warning,
    Color? success,
  }) => SketchyColors(
    mode: mode ?? this.mode,
    ink: ink ?? this.ink,
    paper: paper ?? this.paper,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    info: info ?? this.info,
    warning: warning ?? this.warning,
    success: success ?? this.success,
  );
}

class _ModePalette {
  const _ModePalette({
    required this.ink,
    required this.paper,
    required this.primary,
    required this.secondary,
  });

  final Color ink;
  final Color paper;
  final Color primary;
  final Color secondary;
}

const Map<SketchyColorMode, _ModePalette> _modePalettes =
    <SketchyColorMode, _ModePalette>{
      SketchyColorMode.white: _ModePalette(
        ink: SketchyPalette.ink,
        paper: SketchyPalette.paper,
        primary: SketchyPalette.black,
        secondary: SketchyPalette.white,
      ),
      SketchyColorMode.red: _ModePalette(
        ink: SketchyPalette.redInk,
        paper: SketchyPalette.redPaper,
        primary: SketchyPalette.scarlet,
        secondary: SketchyPalette.lightCoral,
      ),
      SketchyColorMode.orange: _ModePalette(
        ink: SketchyPalette.orangeInk,
        paper: SketchyPalette.orangePaper,
        primary: SketchyPalette.ember,
        secondary: SketchyPalette.lightPeach,
      ),
      SketchyColorMode.yellow: _ModePalette(
        ink: SketchyPalette.yellowInk,
        paper: SketchyPalette.yellowPaper,
        primary: SketchyPalette.lemon,
        secondary: SketchyPalette.lightLemon,
      ),
      SketchyColorMode.green: _ModePalette(
        ink: SketchyPalette.greenInk,
        paper: SketchyPalette.greenPaper,
        primary: SketchyPalette.lime,
        secondary: SketchyPalette.lightSage,
      ),
      SketchyColorMode.cyan: _ModePalette(
        ink: SketchyPalette.cyanInk,
        paper: SketchyPalette.cyanPaper,
        primary: SketchyPalette.teal,
        secondary: SketchyPalette.lightTurquoise,
      ),
      SketchyColorMode.blue: _ModePalette(
        ink: SketchyPalette.blueInk,
        paper: SketchyPalette.bluePaper,
        primary: SketchyPalette.cobalt,
        secondary: SketchyPalette.lightSkyBlue,
      ),
      SketchyColorMode.indigo: _ModePalette(
        ink: SketchyPalette.indigoInk,
        paper: SketchyPalette.indigoPaper,
        primary: SketchyPalette.indigo,
        secondary: SketchyPalette.lightPeriwinkle,
      ),
      SketchyColorMode.violet: _ModePalette(
        ink: SketchyPalette.violetInk,
        paper: SketchyPalette.violetPaper,
        primary: SketchyPalette.violet,
        secondary: SketchyPalette.lightLilac,
      ),
      SketchyColorMode.magenta: _ModePalette(
        ink: SketchyPalette.magentaInk,
        paper: SketchyPalette.magentaPaper,
        primary: SketchyPalette.magenta,
        secondary: SketchyPalette.lightPink,
      ),
      SketchyColorMode.black: _ModePalette(
        ink: SketchyPalette.white,
        paper: SketchyPalette.black,
        primary: SketchyPalette.white,
        secondary: SketchyPalette.black,
      ),
    };
