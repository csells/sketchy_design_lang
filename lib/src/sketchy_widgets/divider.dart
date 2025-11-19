// ignore_for_file: public_member_api_docs
import 'package:flutter/widgets.dart';

import '../widgets/sketchy_frame.dart';

/// Sketchy divider.
///
/// Usage:
/// ```dart
/// Text(
/// 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
/// fontSize: 18.0,
/// color: Colors.blueGrey,
/// ),
/// SizedBox(height: 15.0),
/// SketchyDivider(),
/// Text(
/// 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
/// fontSize: 18.0,
/// color: Colors.blueGrey,
/// ),
/// ```
class SketchyDivider extends StatelessWidget {
  const SketchyDivider({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 16,
    child: Center(
      child: SketchyFrame(
        height: 2,
        fill: SketchyFill.none,
        child: SizedBox.expand(),
      ),
    ),
  );
}
