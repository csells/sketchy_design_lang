import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'app_bar.dart';

/// Minimal scaffold that avoids pulling in Material widgets.
class SketchyScaffold extends StatelessWidget {
  /// Creates a scaffold with optional [appBar], [body], and FAB.
  const SketchyScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.backgroundColor,
  });

  /// Optional Sketchy app bar.
  final SketchyAppBar? appBar;

  /// Primary body content.
  final Widget? body;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Override for the paper background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => ColoredBox(
          color: backgroundColor ?? theme.colors.paper,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    if (appBar != null) appBar!,
                    if (body != null)
                      Expanded(
                        child: DefaultTextStyle(
                          style: theme.typography.body.copyWith(
                            color: theme.colors.ink,
                          ),
                          child: body!,
                        ),
                      ),
                  ],
                ),
                if (floatingActionButton != null)
                  Positioned(
                      right: 24, bottom: 24, child: floatingActionButton!),
              ],
            ),
          ),
        ),
      );
}
