// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';

/// Wired card.
///
/// Usage:
/// ```dart
/// SketchyCard(
///   height: 150.0,
///   fill: false,
///   child: Column(
/// 	mainAxisSize: MainAxisSize.min,
/// 	children: <Widget>[
/// 	  const ListTile(
/// 		leading: Icon(Icons.album),
/// 		title: WiredText('The Enchanted Nightingale'),
/// 		subtitle: WiredText(
/// 			'Music by Julie Gable. Lyrics by Sidney Stein.'),
/// 	  ),
/// 	  Row(
/// 		mainAxisAlignment: MainAxisAlignment.end,
/// 		children: <Widget>[
/// 		  SketchyButton(
/// 			child: const WiredText('BUY TICKETS'),
/// 			onPressed: () {/* ... */},
/// 		  ),
/// 		  const SizedBox(width: 8),
/// 		  SketchyButton(
/// 			child: const WiredText('LISTEN'),
/// 			onPressed: () {/* ... */},
/// 		  ),
/// 		  const SizedBox(width: 8),
/// 		],
/// 	  ),
/// 	],
///   ),
/// ),
/// ```
class SketchyCard extends StatelessWidget {
  const SketchyCard({
    super.key,
    this.child,
    this.fill = false,
    this.height = 130.0,
  });

  /// The [child] contained by the card.
  final Widget? child;

  /// `true` to fill by canvas fill painter, otherwise not.
  final bool fill;

  /// The [height] of this card.
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.transparent,
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    height: height,
    child: Stack(
      children: [
        WiredCanvas(
          painter: WiredRectangleBase(),
          fillerType: fill ? RoughFilter.HachureFiller : RoughFilter.NoFiller,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                child: child,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
