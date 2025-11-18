// ignore_for_file: public_member_api_docs

import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../theme/sketchy_theme.dart';
import 'wired_base.dart';

class SketchyButton extends StatefulWidget {
  const SketchyButton({required this.child, this.onPressed, super.key});

  final Widget child;
  final VoidCallback? onPressed;

  @override
  State<SketchyButton> createState() => _SketchyButtonState();
}

class _SketchyButtonState extends State<SketchyButton> with WiredRepaintMixin {
  late final int _seed = Random().nextInt(1 << 31);

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final drawConfig = DrawConfig.build(
      seed: _seed,
      roughness: _mapRoughness(theme.roughness),
      maxRandomnessOffset: _mapRandomness(theme.roughness),
    );
    final borderStyle = RoughDrawingStyle(
      width: theme.strokeWidth,
      color: theme.borderColor,
    );
    return buildWiredElement(
      child: Container(
        padding: EdgeInsets.zero,
        height: 42,
        decoration: RoughBoxDecoration(
          shape: RoughBoxShape.rectangle,
          drawConfig: drawConfig,
          borderStyle: borderStyle,
        ),
        child: SizedBox(
          height: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.textColor,
              disabledForegroundColor: theme.disabledTextColor,
              textStyle: TextStyle(fontFamily: theme.fontFamily),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: widget.onPressed,
            child: Align(alignment: Alignment.center, child: widget.child),
          ),
        ),
      ),
    );
  }

  double _mapRoughness(double value) => lerpDouble(0.25, 2.1, value) ?? value;

  double _mapRandomness(double value) => lerpDouble(0.6, 3.6, value) ?? value;
}
