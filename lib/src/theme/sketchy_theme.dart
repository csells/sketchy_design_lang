import 'package:flutter/widgets.dart';

import 'sketchy_color_mode.dart';
import 'sketchy_colors.dart';
import 'sketchy_text_case.dart';
import 'sketchy_typography.dart';

/// Complete Sketchy configuration (colors, typography, metrics).
class SketchyThemeData {
  /// Creates a theme with the provided palette and typography.
  const SketchyThemeData({
    required this.mode,
    required this.colors,
    required this.typography,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
    this.roughness = 0.5,
    this.titleCasing = TextCase.none,
  });

  /// Default white theme used by the examples.
  factory SketchyThemeData.white({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.white, roughness: roughness);

  /// Black-mode variant built from a darker palette.
  factory SketchyThemeData.black({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.black, roughness: roughness);

  /// Builds a theme from the predefined [mode].
  factory SketchyThemeData.fromMode(
    SketchyColorMode mode, {
    double roughness = 0.5,
    SketchyTypographyData? typography,
  }) => SketchyThemeData(
    mode: mode,
    colors: SketchyColors.forMode(mode),
    typography: typography ?? SketchyTypographyData.comicShanns(),
    roughness: roughness,
  );

  /// Named mode factories (e.g. `SketchyThemeData.modes.blue()`).
  static const modes = _SketchyThemeModeFactory();

  /// Active color mode.
  final SketchyColorMode mode;

  /// Colors used throughout Sketchy widgets.
  final SketchyColors colors;

  /// Typography styles used for text rendering.
  final SketchyTypographyData typography;

  /// Default stroke width for drawn outlines.
  final double strokeWidth;

  /// Default border radius for card-like widgets.
  final double borderRadius;

  /// Normalized roughness control (0 = straight, 1 = max wobble).
  final double roughness;

  /// Text casing transformation applied to labels and UI text.
  final TextCase titleCasing;

  /// Returns a new theme with the provided overrides.
  SketchyThemeData copyWith({
    SketchyColorMode? mode,
    SketchyColors? colors,
    SketchyTypographyData? typography,
    double? strokeWidth,
    double? borderRadius,
    double? roughness,
    TextCase? titleCasing,
  }) {
    final resolvedMode = mode ?? this.mode;
    final resolvedColors =
        colors ??
        (resolvedMode == this.mode
            ? this.colors
            : SketchyColors.forMode(resolvedMode));
    return SketchyThemeData(
      mode: resolvedMode,
      colors: resolvedColors,
      typography: typography ?? this.typography,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      roughness: roughness ?? this.roughness,
      titleCasing: titleCasing ?? this.titleCasing,
    );
  }
}

class _SketchyThemeModeFactory {
  const _SketchyThemeModeFactory();

  SketchyThemeData white({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.white, roughness: roughness);

  SketchyThemeData red({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.red, roughness: roughness);

  SketchyThemeData orange({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.orange, roughness: roughness);

  SketchyThemeData yellow({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.yellow, roughness: roughness);

  SketchyThemeData green({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.green, roughness: roughness);

  SketchyThemeData cyan({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.cyan, roughness: roughness);

  SketchyThemeData blue({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.blue, roughness: roughness);

  SketchyThemeData indigo({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.indigo, roughness: roughness);

  SketchyThemeData violet({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.violet, roughness: roughness);

  SketchyThemeData magenta({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.magenta, roughness: roughness);

  SketchyThemeData black({double roughness = 0.5}) =>
      SketchyThemeData.fromMode(SketchyColorMode.black, roughness: roughness);
}

/// Inherited widget wiring [SketchyThemeData] into the tree.
class SketchyTheme extends InheritedWidget {
  /// Creates a [SketchyTheme] that exposes [data] to descendants.
  const SketchyTheme({required this.data, required super.child, super.key});

  /// Active theme data.
  final SketchyThemeData data;

  /// Returns the nearest [SketchyThemeData] from the widget tree.
  static SketchyThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<SketchyTheme>();
    if (theme == null) {
      throw FlutterError(
        'No SketchyTheme found in context. Wrap your app with SketchyApp '
        'or SketchyTheme.',
      );
    }
    return theme.data;
  }

  @override
  bool updateShouldNotify(SketchyTheme oldWidget) => data != oldWidget.data;
}

/// Convenience accessors consumed by the core Sketchy widgets. They translate
/// the generic theme data into the colors and metrics those widgets expect
/// without duplicating configuration objects.
extension SketchyThemeTokens on SketchyThemeData {
  /// Outlines/text always use the active ink color.
  Color get borderColor => colors.ink;

  /// Default fill used for primitive backgrounds.
  Color get fillColor => colors.paper;

  /// Primary text color (also the ink tone).
  Color get textColor => colors.ink;

  /// Disabled text inherits ink with reduced opacity so it remains on-brand.
  Color get disabledTextColor => colors.ink.withValues(alpha: 0.35);

  /// Font family extracted from the body style with a sensible fallback.
  String get fontFamily =>
      typography.body.fontFamily ??
      typography.title.fontFamily ??
      'ComicShanns';
}
