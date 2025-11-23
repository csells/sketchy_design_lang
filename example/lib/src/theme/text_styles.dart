import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

TextStyle titleStyle(SketchyThemeData theme) =>
    theme.typography.title.copyWith(fontWeight: FontWeight.bold);

TextStyle bodyStyle(SketchyThemeData theme) => theme.typography.body;

TextStyle mutedStyle(SketchyThemeData theme) =>
    theme.typography.caption.copyWith(color: const Color(0xFF9E9E9E));

TextStyle fieldLabelStyle(SketchyThemeData theme) =>
    theme.typography.label.copyWith(fontWeight: FontWeight.bold);

TextStyle buttonLabelStyle(SketchyThemeData theme, {Color? color}) =>
    theme.typography.label.copyWith(fontWeight: FontWeight.bold, color: color);
