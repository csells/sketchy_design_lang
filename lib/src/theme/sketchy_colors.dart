import 'dart:ui';

import '../../sketchy_design_lang.dart'
    show SketchyThemeData, SketchyThemeTokens;
import 'sketchy_theme.dart' show SketchyThemeData, SketchyThemeTokens;

/// Static raw color palette for the Sketchy design language.
///
/// These are the primitive values used to build [SketchyThemeData].
/// Do not use these directly in widgets; prefer [SketchyThemeTokens].
class SketchyColors {
  const SketchyColors._();

  // -- Base --
  /// Pure black.
  static const Color black = Color(0xFF000000);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent.
  static const Color transparent = Color(0x00000000);

  // -- Grays --
  /// Dark charcoal gray.
  static const Color charcoal = Color(0xFF0F0F0F);

  /// Slate gray.
  static const Color slate = Color(0xFF3A3A3A);

  /// Light ash gray.
  static const Color ash = Color(0xFFE0E0E0);

  /// Very light gray.
  static const Color lightGray = Color(0xFFF5F5F5);

  // -- Reds --
  /// Bright scarlet red.
  static const Color scarlet = Color(0xFFE53935);

  /// Deep scarlet red.
  static const Color darkScarlet = Color(0xFF981200);

  /// Deep maroon red.
  static const Color maroon = Color(0xFF5C1111);

  /// Pale blush red.
  static const Color blush = Color(0xFFF5CCCC);

  /// Rosewash.
  static const Color rosewash = Color(0xFFE6B9B0);

  /// Light coral red.
  static const Color lightCoral = Color(0xFFFFCDD2);

  /// Carmine red (used for errors).
  static const Color carmine = Color(0xFFD64550);

  /// Salmon red (used for warnings).
  static const Color salmon = Color(0xFFED6A5A);

  /// Red primary.
  static const Color red = Color(0xFFFF2500);

  // -- Oranges --
  /// Ember orange.
  static const Color ember = Color(0xFFFB8C00);

  /// Orange primary.
  static const Color orange = Color(0xFFFF9A02);

  /// Rust orange.
  static const Color rust = Color(0xFF7A2F05);

  /// Apricot orange.
  static const Color apricot = Color(0xFFFFF4E9);

  /// Peach orange.
  static const Color peach = Color(0xFFFFE0B2);

  /// Creamsicle orange.
  static const Color creamsicle = Color(0xFFFCE5CC);

  // -- Yellows --
  /// Lemon yellow.
  static const Color lemon = Color(0xFFFBC02D);

  /// Yellow primary.
  static const Color yellow = Color(0xFFFFFB03);

  /// Ochre yellow.
  static const Color ochre = Color(0xFF7C5B04);

  /// Cream yellow.
  static const Color cream = Color(0xFFFFFBE6);

  /// Light lemon yellow.
  static const Color lightLemon = Color(0xFFFFF59D);

  /// Buttercream yellow.
  static const Color buttercream = Color(0xFFFFF3CC);

  // -- Greens --
  /// Lime green.
  static const Color lime = Color(0xFF2E7D32);

  /// Green primary.
  static const Color green = Color(0xFF09F902);

  /// Forest green.
  static const Color forestGreen = Color(0xFF184B2B);

  /// Mint green.
  static const Color mint = Color(0xFFF1FFF4);

  /// Mint fade.
  static const Color mintFade = Color(0xFFD9EAD3);

  /// Light sage green.
  static const Color lightSage = Color(0xFFC8E6C9);

  /// Seafoam green (used for success).
  static const Color seafoam = Color(0xFF6C9A8B);

  // -- Cyans --
  /// Teal cyan.
  static const Color teal = Color(0xFF00ACC1);

  /// Cyan primary.
  static const Color cyan = Color(0xFF0AFDFF);

  /// Deep teal cyan.
  static const Color deepTeal = Color(0xFF06464E);

  /// Aqua cyan.
  static const Color aqua = Color(0xFFF0FDFF);

  /// Ice mist.
  static const Color iceMist = Color(0xFFD0E1E3);

  /// Turquoise cyan.
  static const Color turquoise = Color(0xFFB2EBF2);

  // -- Blues --
  /// Cobalt blue.
  static const Color cobalt = Color(0xFF1976D2);

  /// Blue primary.
  static const Color blue = Color(0xFF0133FF);

  /// Navy blue.
  static const Color navy = Color(0xFF0F305D);

  /// Cloud blue.
  static const Color cloud = Color(0xFFF0F6FF);

  /// Sky blue.
  static const Color sky = Color(0xFFBBDEFB);

  /// Skywash blue.
  static const Color skywash = Color(0xFFD0E3F2);

  /// Dusty blue.
  static const Color dusty = Color(0xFF4A86E8);

  /// Powder blue.
  static const Color powderBlue = Color(0xFFC9DAF8);

  /// Steel blue (used for info).
  static const Color steel = Color(0xFF4F7CAC);

  // -- Indigos --
  /// Indigo.
  static const Color indigo = Color(0xFF5C6BC0);

  /// Midnight indigo.
  static const Color midnight = Color(0xFF261E61);

  /// Lavender indigo.
  static const Color lavender = Color(0xFFF4F0FF);

  /// Periwinkle indigo.
  static const Color periwinkle = Color(0xFFD1C4E9);

  // -- Violets --
  /// Violet primary.
  static const Color violet = Color(0xFF9938FF);

  /// Plum violet.
  static const Color plum = Color(0xFF3C164D);

  /// Orchid violet.
  static const Color orchid = Color(0xFFFFF0FF);

  /// Lilac violet.
  static const Color lilac = Color(0xFFE1BEE7);

  /// Lavender haze.
  static const Color lavenderHaze = Color(0xFFD9D1E9);

  // -- Pinks --
  /// Pink primary.
  static const Color pink = Color(0xFFFF40FF);

  /// Petal blush.
  static const Color petalBlush = Color(0xFFEAD1DC);

  // -- Chat Theme Colors --
  /// Warm parchment paper color for chat backgrounds.
  static const Color parchment = Color(0xFFFAF6F0);

  /// Sepia ink color for chat text.
  static const Color sepia = Color(0xFF4A3728);

  /// Soft lavender for AI message bubbles.
  static const Color chatLavender = Color(0xFFE8E0F0);

  /// Soft sage green for user message bubbles.
  static const Color chatSage = Color(0xFFD8ECD8);

  /// Online status green.
  static const Color onlineGreen = Color(0xFF4CAF50);

  // -- Magentas --
  /// Magenta.
  static const Color magenta = Color(0xFFD81B60);

  /// Wine magenta.
  static const Color wine = Color(0xFF5A0E2A);

  /// Rose magenta.
  static const Color rose = Color(0xFFFFF1F7);

  /// Pink magenta.
  static const Color pastelPink = Color(0xFFF8BBD0);
}
