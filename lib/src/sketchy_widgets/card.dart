import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Sketchy card.
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
/// 		title: Text('The Enchanted Nightingale'),
/// 		subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
/// 	  ),
/// 	  Row(
/// 		mainAxisAlignment: MainAxisAlignment.end,
/// 		children: <Widget>[
/// 		  SketchyButton(onPressed: () {/* ... */}, child: const Text('BUY TICKETS')),
/// 		  const SizedBox(width: 8),
/// 		  SketchyButton(onPressed: () {/* ... */}, child: const Text('LISTEN')),
/// 		  const SizedBox(width: 8),
/// 		],
/// 	  ),
/// 	],
///   ),
/// ),
/// ```
class SketchyCard extends StatelessWidget {
  /// Builds a card with a sketchy border around [child].
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
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SketchyFrame(
      height: height,
      padding: const EdgeInsets.all(16),
      strokeColor: theme.borderColor,
      strokeWidth: theme.strokeWidth,
      fill: fill ? SketchyFill.hachure : SketchyFill.none,
      cornerRadius: theme.borderRadius,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
