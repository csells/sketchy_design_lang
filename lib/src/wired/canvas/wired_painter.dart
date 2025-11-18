// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import '../../theme/sketchy_theme.dart';
import 'wired_painter_base.dart';

class WiredPainter extends CustomPainter {
  WiredPainter(this.drawConfig, this.filler, this.painter, this.theme);
  final DrawConfig drawConfig;
  final Filler filler;
  final WiredPainterBase painter;
  final SketchyThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    drawConfig.randomizer.reset();
    painter.paintRough(canvas, size, drawConfig, filler, theme);
  }

  @override
  bool shouldRepaint(WiredPainter oldDelegate) =>
      oldDelegate.drawConfig != drawConfig ||
      oldDelegate.theme != theme ||
      oldDelegate.filler != filler;
}
