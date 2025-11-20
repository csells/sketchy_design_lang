import 'package:flutter/widgets.dart';

import 'sketchy_colors.dart';
import 'sketchy_text_case.dart';
import 'sketchy_themes.dart';
import 'sketchy_typography.dart';

/// Complete Sketchy configuration (colors, typography, metrics).
class SketchyThemeData {
  /// Creates a theme with the provided palette and typography.
  const SketchyThemeData({
    required this.inkColor,
    required this.paperColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.errorColor,
    required this.typography,
    this.strokeWidth = 2.0,
    this.borderRadius = 0,
    this.roughness = 0.5,
    this.textCase = TextCase.none,
  });

  /// Builds a theme from the predefined [theme].
  factory SketchyThemeData.fromTheme(
    SketchyThemes theme, {
    Brightness brightness = Brightness.light,
    double roughness = 0.5,
    SketchyTypographyData? typography,
    TextCase textCase = TextCase.none,
    double strokeWidth = 2.0,
    double borderRadius = 0,
  }) {
    final (ink, paper, primary, secondary) = theme.palette;

    // In dark mode, we swap ink/paper to create a dark theme from the same palette.
    // We also swap primary/secondary to ensure large fills (secondary) are darker
    // and accents (primary) pop more.
    final isDark = brightness == Brightness.dark;
    return SketchyThemeData(
      inkColor: isDark ? paper : ink,
      paperColor: isDark ? ink : paper,
      primaryColor: isDark ? secondary : primary,
      secondaryColor: isDark ? primary : secondary,
      errorColor: SketchyColors.carmine,
      typography: typography ?? SketchyTypographyData.comicShanns(),
      roughness: roughness,
      strokeWidth: strokeWidth,
      textCase: textCase,
      borderRadius: borderRadius,
    );
  }

  /// Primary stroke color used for outlines and text.
  final Color inkColor;

  /// Background color emulating paper.
  final Color paperColor;

  /// Bold accent color for primary actions.
  final Color primaryColor;

  /// Softer accent variant for fills.
  final Color secondaryColor;

  /// Semantic color for errors and validation.
  final Color errorColor;

  /// Typography styles used for text rendering.
  final SketchyTypographyData typography;

  /// Default stroke width for drawn outlines.
  final double strokeWidth;

  /// Default border radius for card-like widgets.
  final double borderRadius;

  /// Normalized roughness control (0 = straight, 1 = max wobble).
  final double roughness;

  /// Text casing transformation applied to labels and UI text.
  final TextCase textCase;

  /// Returns a new theme with the provided overrides.
  SketchyThemeData copyWith({
    Color? inkColor,
    Color? paperColor,
    Color? primaryColor,
    Color? secondaryColor,
    Color? errorColor,
    SketchyTypographyData? typography,
    double? strokeWidth,
    double? borderRadius,
    double? roughness,
    TextCase? textCase,
  }) => SketchyThemeData(
    inkColor: inkColor ?? this.inkColor,
    paperColor: paperColor ?? this.paperColor,
    primaryColor: primaryColor ?? this.primaryColor,
    secondaryColor: secondaryColor ?? this.secondaryColor,
    errorColor: errorColor ?? this.errorColor,
    typography: typography ?? this.typography,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    borderRadius: borderRadius ?? this.borderRadius,
    roughness: roughness ?? this.roughness,
    textCase: textCase ?? this.textCase,
  );
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

  /// Builds a widget that depends on the current theme.
  ///
  /// This is a convenience method that provides cleaner syntax for accessing
  /// the theme without explicitly calling [of]:
  ///
  /// ```dart
  /// SketchyTheme.consumer(
  ///   builder: (context, theme) => Text(
  ///     'Hello',
  ///     style: TextStyle(color: theme.inkColor),
  ///   ),
  /// )
  /// ```
  static Widget consumer({
    required Widget Function(BuildContext, SketchyThemeData) builder,
  }) =>
      Builder(builder: (context) => builder(context, SketchyTheme.of(context)));

  @override
  bool updateShouldNotify(SketchyTheme oldWidget) => data != oldWidget.data;
}

/// Convenience accessors consumed by the core Sketchy widgets. They translate
/// the generic theme data into the colors and metrics those widgets expect
/// without duplicating configuration objects.
extension SketchyThemeTokens on SketchyThemeData {
  /// Outlines/text always use the active ink color.
  Color get borderColor => inkColor;

  /// Default fill used for primitive backgrounds.
  Color get fillColor => paperColor;

  /// Primary text color (also the ink tone).
  Color get textColor => inkColor;

  /// Disabled text inherits ink with reduced opacity so it remains on-brand.
  Color get disabledTextColor => inkColor.withValues(alpha: 0.35);

  /// Muted variant of the ink color for secondary text or grid lines.
  Color get mutedColor => inkColor.withValues(alpha: 0.3);

  /// Font family extracted from the body style with a sensible fallback.
  String get fontFamily =>
      typography.body.fontFamily ??
      typography.title.fontFamily ??
      'ComicShanns';

  /// Text color to use on top of the primary color.
  Color get onPrimaryColor => _bestContrast(primaryColor, inkColor, paperColor);

  /// Text color to use on top of the secondary color.
  Color get onSecondaryColor =>
      _bestContrast(secondaryColor, inkColor, paperColor);

  Color _bestContrast(Color bg, Color option1, Color option2) {
    // Simple luminance check: if bg is dark, we want light text.
    // If bg is light, we want dark text.
    final isDark = bg.computeLuminance() < 0.5;

    // We assume one of ink/paper is light and the other is dark.
    // If ink is light (Dark Mode), we return ink when bg is dark.
    if (isDark) {
      return option1.computeLuminance() > 0.5 ? option1 : option2;
    } else {
      return option1.computeLuminance() < 0.5 ? option1 : option2;
    }
  }
}
