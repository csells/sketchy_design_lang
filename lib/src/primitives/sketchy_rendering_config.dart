/// Configuration constants for the sketchy rough renderer.
class SketchyRenderingConfig {
  const SketchyRenderingConfig._();

  /// Minimum roughness scaling factor.
  static const double roughnessMin = 0.35;

  /// Maximum roughness scaling factor.
  static const double roughnessMax = 2.2;

  /// Minimum bowing scaling factor.
  static const double bowingMin = 0.04;

  /// Maximum bowing scaling factor.
  static const double bowingMax = 1.1;

  /// Minimum randomness offset scaling factor.
  static const double maxRandomnessOffsetMin = 0.4;

  /// Maximum randomness offset scaling factor.
  static const double maxRandomnessOffsetMax = 3.4;

  /// Curve fitting parameter.
  static const double curveFitting = 0.9;

  /// Minimum hachure gap scaling.
  static const double hachureGapMin = 6;

  /// Maximum hachure gap scaling.
  static const double hachureGapMax = 16;

  /// Default hachure gap.
  static const double defaultHachureGap = 10;

  /// Minimum fill weight scaling.
  static const double fillWeightMin = 0.6;

  /// Maximum fill weight scaling.
  static const double fillWeightMax = 1.8;

  /// Default fill weight.
  static const double defaultFillWeight = 1;
}
