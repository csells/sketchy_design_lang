import 'package:flutter/painting.dart';

/// Canonical named colors used across Sketchy.
class SketchyPalette {
  const SketchyPalette._();

  /// Default dark stroke color for light backgrounds.
  static const Color ink = Color(0xFF000000);

  /// Default light background color (pure white).
  static const Color paper = Color(0xFFFFFFFF);

  /// Bold red accent color.
  static const Color scarlet = Color(0xFFE53935);

  /// Warm orange accent color.
  static const Color ember = Color(0xFFFB8C00);

  /// Bright yellow accent color.
  static const Color lemon = Color(0xFFFBC02D);

  /// Fresh green accent color.
  static const Color lime = Color(0xFF2E7D32);

  /// Cool cyan accent color.
  static const Color teal = Color(0xFF00ACC1);

  /// Rich blue accent color.
  static const Color cobalt = Color(0xFF1976D2);

  /// Deep indigo accent color.
  static const Color indigo = Color(0xFF5C6BC0);

  /// Vivid violet accent color.
  static const Color violet = Color(0xFF8E24AA);

  /// Punchy magenta accent color.
  static const Color magenta = Color(0xFFD81B60);

  /// Dark background color for dark mode.
  static const Color charcoal = Color(0xFF0F0F0F);

  /// Informational semantic color.
  static const Color info = Color(0xFF4F7CAC);

  /// Warning semantic color.
  static const Color warning = Color(0xFFED6A5A);

  /// Success semantic color.
  static const Color success = Color(0xFF6C9A8B);

  /// Error semantic color.
  static const Color error = Color(0xFFD64550);

  /// Shadow color for canvas elements.
  static const Color canvasShadow = Color(0x11000000);

  /// Grid line color for layouts.
  static const Color gridLine = Color(0xFF1C1C1C);

  /// Light cream accent color.
  static const Color cream = Color(0xFFFFF5DA);

  /// Light sky blue accent color.
  static const Color sky = Color(0xFFE8F0FF);

  // Mode-specific ink colors (dark text/stroke for each mode)
  /// Deep red ink for red mode.
  static const Color redInk = Color(0xFF5C1111);

  /// Deep brown-orange ink for orange mode.
  static const Color orangeInk = Color(0xFF7A2F05);

  /// Golden brown ink for yellow mode.
  static const Color yellowInk = Color(0xFF7C5B04);

  /// Deep forest green ink for green mode.
  static const Color greenInk = Color(0xFF184B2B);

  /// Deep teal ink for cyan mode.
  static const Color cyanInk = Color(0xFF06464E);

  /// Navy blue ink for blue mode.
  static const Color blueInk = Color(0xFF0F305D);

  /// Deep purple ink for indigo mode.
  static const Color indigoInk = Color(0xFF261E61);

  /// Deep plum ink for violet mode.
  static const Color violetInk = Color(0xFF3C164D);

  /// Deep wine ink for magenta mode.
  static const Color magentaInk = Color(0xFF5A0E2A);

  /// Light gray ink for dark mode.
  static const Color lightGray = Color(0xFFF5F5F5);

  // Mode-specific paper colors (light backgrounds for each mode)
  /// Pale rose paper for red mode.
  static const Color redPaper = Color(0xFFFFF3F0);

  /// Pale apricot paper for orange mode.
  static const Color orangePaper = Color(0xFFFFF4E9);

  /// Pale yellow paper for yellow mode.
  static const Color yellowPaper = Color(0xFFFFFBE6);

  /// Pale mint paper for green mode.
  static const Color greenPaper = Color(0xFFF1FFF4);

  /// Pale aqua paper for cyan mode.
  static const Color cyanPaper = Color(0xFFF0FDFF);

  /// Pale sky paper for blue mode.
  static const Color bluePaper = Color(0xFFF0F6FF);

  /// Pale lavender paper for indigo mode.
  static const Color indigoPaper = Color(0xFFF4F0FF);

  /// Pale orchid paper for violet mode.
  static const Color violetPaper = Color(0xFFFFF0FF);

  /// Pale blush paper for magenta mode.
  static const Color magentaPaper = Color(0xFFFFF1F7);

  // Mode-specific secondary colors (fills for each mode)
  /// Pure white secondary for light mode.
  static const Color white = Color(0xFFFFFFFF);

  /// Light coral secondary for red mode.
  static const Color lightCoral = Color(0xFFFFCDD2);

  /// Light peach secondary for orange mode.
  static const Color lightPeach = Color(0xFFFFE0B2);

  /// Light lemon secondary for yellow mode.
  static const Color lightLemon = Color(0xFFFFF59D);

  /// Light sage secondary for green mode.
  static const Color lightSage = Color(0xFFC8E6C9);

  /// Light turquoise secondary for cyan mode.
  static const Color lightTurquoise = Color(0xFFB2EBF2);

  /// Light sky blue secondary for blue mode.
  static const Color lightSkyBlue = Color(0xFFBBDEFB);

  /// Light periwinkle secondary for indigo mode.
  static const Color lightPeriwinkle = Color(0xFFD1C4E9);

  /// Light lilac secondary for violet mode.
  static const Color lightLilac = Color(0xFFE1BEE7);

  /// Light pink secondary for magenta mode.
  static const Color lightPink = Color(0xFFF8BBD0);

  /// Charcoal gray secondary for dark mode.
  static const Color darkGray = Color(0xFF1B1B1B);

  // Utility colors
  /// Pure black for drawing and overlays.
  static const Color black = Color(0xFF000000);

  /// Semi-transparent black scrim for dialogs and overlays.
  static const Color scrim = Color(0xAA000000);
}
