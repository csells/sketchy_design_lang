// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../theme/sketchy_theme.dart';
import 'wired_base.dart';

/// Wired button.
///
/// Usage:
/// ```dart
/// SketchyButton(
///  child: WiredText('Wired Button'),
///  onPressed: () {
///   print('Wired Button');
///  },
/// ),
/// ```
class SketchyButton extends WiredBaseWidget {
  const SketchyButton({required this.child, this.onPressed, super.key});

  /// Typically the button's label.
  final Widget child;

  /// Called when the button is tapped
  final VoidCallback? onPressed;

  @override
  @override
  Widget buildWiredElement(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final drawConfig = DrawConfig.build(
      roughness: theme.roughness,
      maxRandomnessOffset: 2 * theme.roughness,
      seed: Random().nextInt(1 << 31),
    );
    return Container(
      padding: EdgeInsets.zero,
      height: 42,
      decoration: RoughBoxDecoration(
        shape: RoughBoxShape.rectangle,
        drawConfig: drawConfig,
        borderStyle: RoughDrawingStyle(
          width: theme.strokeWidth,
          color: theme.borderColor,
        ),
      ),
      child: SizedBox(
        height: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: theme.textColor,
            disabledForegroundColor: theme.disabledTextColor,
            textStyle: TextStyle(fontFamily: theme.fontFamily),
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
