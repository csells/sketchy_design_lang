// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:rough_flutter/rough_flutter.dart';
import '../../theme/sketchy_theme.dart';

abstract class WiredPainterBase {
  void paintRough(
    Canvas canvas,
    Size size,
    DrawConfig drawConfig,
    Filler filler,
    SketchyThemeData theme,
  );
}
