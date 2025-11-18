// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'canvas/wired_canvas.dart';
import 'wired_base.dart';

/// Wired dialog.
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
/// 					WiredText(
/// 					  'Title',
/// 					  fontSize: 20.0,
/// 					  fontWeight: FontWeight.bold,
/// 					),
/// 					SizedBox(height: 15.0),
/// 					WiredText(
/// 					  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
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
/// 	child: WiredText('Open wired dialog'),
///   ),
/// ```
class SketchyDialog extends StatelessWidget {
  const SketchyDialog({required this.child, super.key, this.padding});

  /// The content in dialog.
  final Widget child;

  /// The padding for dialog's content, defaults to 20.0 if null.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Dialog(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: WiredCanvas(
            painter: WiredRectangleBase(),
            fillerType: RoughFilter.NoFiller,
          ),
        ),
        Padding(padding: padding ?? const EdgeInsets.all(20), child: child),
      ],
    ),
  );
}
