import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_fab_location.dart';

export 'sketchy_fab_location.dart';

/// Callback for when a drawer is opened or closed.
typedef SketchyDrawerCallback = void Function(bool isOpened);

/// Minimal scaffold that avoids pulling in Material widgets.
class SketchyScaffold extends StatelessWidget {
  /// Creates a visual scaffold for material design widgets.
  const SketchyScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  });

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The primary content of the scaffold.
  final Widget? body;

  /// A button displayed floating above [body].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  final SketchyFabLocation? floatingActionButtonLocation;

  /// A set of buttons that are displayed at the bottom of the scaffold.
  final List<Widget>? persistentFooterButtons;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices.
  final Widget? drawer;

  /// Optional callback that is called when the [drawer] is opened or closed.
  final SketchyDrawerCallback? onDrawerChanged;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices.
  final Widget? endDrawer;

  /// Optional callback that is called when the [endDrawer] is opened or closed.
  final SketchyDrawerCallback? onEndDrawerChanged;

  /// A bottom navigation bar to display at the bottom of the scaffold.
  final Widget? bottomNavigationBar;

  /// The persistent bottom sheet to display.
  final Widget? bottomSheet;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard.
  final bool? resizeToAvoidBottomInset;

  /// Whether this scaffold is being displayed at the top of the screen.
  final bool primary;

  /// Configuration for drag behavior.
  final DragStartBehavior drawerDragStartBehavior;

  /// If true, and [bottomNavigationBar] or [persistentFooterButtons] is
  /// specified, then the [body] extends to the bottom of the Scaffold.
  final bool extendBody;

  /// If true, and an [appBar] is specified, then the height of the [body] is
  /// extended to include the height of the app bar and the top of the body is
  /// aligned with the top of the app bar.
  final bool extendBodyBehindAppBar;

  /// The color to use for the scrim that obscures primary content while a
  /// drawer is open.
  final Color? drawerScrimColor;

  /// The width of the area within which a horizontal swipe will open the
  /// drawer.
  final double? drawerEdgeDragWidth;

  /// Determines if the [drawer] can be opened with a drag gesture.
  final bool drawerEnableOpenDragGesture;

  /// Determines if the [endDrawer] can be opened with a drag gesture.
  final bool endDrawerEnableOpenDragGesture;

  /// Restoration ID to save and restore the state of the [SketchyScaffold].
  final String? restorationId;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => ColoredBox(
      color: backgroundColor ?? theme.paperColor,
      child: SafeArea(
        top: primary,
        bottom: true,
        child: Stack(
          children: [
            Column(
              children: [
                if (appBar != null) appBar!,
                if (body != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style: theme.typography.body.copyWith(
                        color: theme.inkColor,
                      ),
                      child: body!,
                    ),
                  )
                else
                  const Spacer(),
                if (bottomSheet != null) bottomSheet!,
                if (bottomNavigationBar != null) bottomNavigationBar!,
              ],
            ),
            if (floatingActionButton != null)
              Positioned(right: 24, bottom: 24, child: floatingActionButton!),
            // Drawer and endDrawer are not fully implemented in SketchyScaffold
            // yet. This preserves the existing behavior while exposing the API.
          ],
        ),
      ),
    ),
  );
}
