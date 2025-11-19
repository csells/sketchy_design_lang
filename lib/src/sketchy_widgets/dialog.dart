import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

const _kDialogMinWidth = 280;
const _kDialogMaxWidth = 560;
const _kDialogMargin = 24.0;

/// Sketchy dialog.
///
/// Usage:
/// ```dart
/// SketchyButton(
/// 	onPressed: () {
/// 	  showDialog(
/// 		context: context,
/// 		builder: (context) {
/// 		  return Center(
/// 			child: Container(
/// 			  height: 480.0,
/// 			  child: SketchyDialog(
/// 				child: Column(
/// 				  crossAxisAlignment: CrossAxisAlignment.start,
/// 				  children: [
/// 					Text(
/// 					  'Title',
/// 					  fontSize: 20.0,
/// 					  fontWeight: FontWeight.bold,
/// 					),
/// 					SizedBox(height: 15.0),
/// 					Text(
/// 					  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
/// 					),
/// 					SizedBox(height: 15.0),
/// 					Row(
/// 					  mainAxisAlignment: MainAxisAlignment.end,
/// 					  children: [
/// 						SketchyButton(
/// 						  child: Text('OK'),
/// 						  onPressed: () {
/// 							Navigator.of(context).pop();
/// 						  },
/// 						),
/// 					  ],
/// 					),
/// 				  ],
/// 				),
/// 			  ),
/// 			),
/// 		  );
/// 		},
/// 	  );
/// 	},
/// 	child: Text('Open dialog'),
///   ),
/// ```
class SketchyDialog extends StatelessWidget {
  /// Builds a sketchy-styled dialog containing [child].
  const SketchyDialog({required this.child, super.key, this.padding});

  /// The content in dialog.
  final Widget child;

  /// The padding for dialog's content, defaults to 20.0 if null.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final viewWidth = (mediaQuery.size.width - _kDialogMargin * 2)
        .clamp(0.0, double.infinity);
    final safeWidth = viewWidth == 0 ? mediaQuery.size.width : viewWidth;
    final minWidth = math.min(_kDialogMinWidth.toDouble(), safeWidth);
    final maxWidth = math.max(
      minWidth,
      math.min(_kDialogMaxWidth.toDouble(), safeWidth),
    );
    final availableHeight = mediaQuery.size.height - _kDialogMargin * 2;
    final maxHeight =
        availableHeight > 0 ? availableHeight : mediaQuery.size.height;
    final resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 24);

    final widthConstraints = BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: mediaQuery.viewInsets +
          const EdgeInsets.symmetric(
            horizontal: _kDialogMargin,
            vertical: _kDialogMargin,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: widthConstraints,
              child: ClipRect(
                child: SketchyFrame(
                  padding: resolvedPadding,
                  cornerRadius: 0,
                  fill: SketchyFill.solid,
                  fillColor: theme.colors.paper,
                  strokeColor: theme.borderColor,
                  strokeWidth: theme.strokeWidth,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
