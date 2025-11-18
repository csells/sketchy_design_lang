// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'canvas/wired_canvas.dart';
import 'wired_base.dart';

/// Wired divider.
///
/// Usage:
/// ```dart
/// WiredText(
/// 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
/// fontSize: 18.0,
/// color: Colors.blueGrey,
/// ),
/// SizedBox(height: 15.0),
/// SketchyDivider(),
/// WiredText(
/// 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
/// fontSize: 18.0,
/// color: Colors.blueGrey,
/// ),
/// ```
class SketchyDivider extends StatelessWidget {
  const SketchyDivider({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      SizedBox(
        height: 1,
        width: double.infinity,
        child: WiredCanvas(
          painter: WiredLineBase(x1: 0, y1: 0, x2: double.infinity, y2: 0),
          fillerType: RoughFilter.NoFiller,
        ),
      ),
      const Divider(color: Colors.transparent),
    ],
  );
}
