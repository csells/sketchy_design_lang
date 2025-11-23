import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';

/// Rough-styled app bar used by Sketchy screens.
class AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a sketchy app bar.
  const AppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) : margin = margin ?? const EdgeInsets.all(16),
       padding = padding ?? margin ?? const EdgeInsets.all(16);

  /// A widget to display before the [title].
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  /// This widget is stacked behind the toolbar and the tab bar. (Unused)
  final Widget? flexibleSpace;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// The z-coordinate at which to place this app bar relative to its parent.
  /// (Unused)
  final double? elevation;

  /// The elevation to use when scrolled under. (Unused)
  final double? scrolledUnderElevation;

  /// A check that specifies which notifications should trigger scroll under
  /// state.
  final bool Function(ScrollNotification) notificationPredicate;

  /// The color of the shadow below the app bar. (Unused)
  final Color? shadowColor;

  /// The surface tint color.
  final Color? surfaceTintColor;

  /// The shape of the app bar's material's shape as well as its shadow.
  final ShapeBorder? shape;

  /// The background color.
  final Color? backgroundColor;

  /// The default color for Text and Icons within the app bar.
  final Color? foregroundColor;

  /// The color, opacity, and size to use for app bar icons.
  final IconThemeData? iconTheme;

  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's actions.
  final IconThemeData? actionsIconTheme;

  /// Whether this app bar is being displayed at the top of the screen.
  final bool primary;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Whether the title should be wrapped with header semantics.
  final bool excludeHeaderSemantics;

  /// The spacing around [title] content on the horizontal axis.
  final double? titleSpacing;

  /// How opaque the toolbar part of the app bar is.
  final double toolbarOpacity;

  /// How opaque the bottom part of the app bar is.
  final double bottomOpacity;

  /// Defines the height of the toolbar component of an [AppBar].
  final double? toolbarHeight;

  /// Defines the width of [leading] widget.
  final double? leadingWidth;

  /// The default text style for the AppBar's [leading], and [actions] widgets,
  /// but not its [title].
  final TextStyle? toolbarTextStyle;

  /// The default text style for the AppBar's [title] widget.
  final TextStyle? titleTextStyle;

  /// Specifies the style to use for the system overlays that overlap the
  /// AppBar.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Forces the AppBar to be transparent.
  final bool forceMaterialTransparency;

  /// The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  /// Outer margin applied around the app bar surface.
  final EdgeInsetsGeometry margin;

  /// Inner padding applied to the sketched surface.
  final EdgeInsetsGeometry padding;

  @override
  Size get preferredSize {
    final resolved = padding.resolve(TextDirection.ltr);
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(48 + resolved.vertical + bottomHeight);
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
      final resolvedPadding = padding.resolve(direction);

      Widget appBarContent = Row(
        children: [
          if (leading != null)
            SizedBox(width: leadingWidth, child: leading)
          else if (automaticallyImplyLeading)
            const SizedBox.shrink(), // Placeholder for back button logic
          if (leading != null) const SizedBox(width: 12),
          Expanded(
            child: DefaultTextStyle(
              style:
                  titleTextStyle ??
                  theme.typography.title.copyWith(
                    color: foregroundColor ?? theme.inkColor,
                  ),
              child: title ?? const SizedBox.shrink(),
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...actions!.map(
              (widget) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: widget,
              ),
            ),
          ],
        ],
      );

      if (bottom != null) {
        appBarContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: [appBarContent, bottom!],
        );
      }

      return Padding(
        padding: margin.resolve(direction),
        child: SketchySurface(
          padding: resolvedPadding,
          fillColor: backgroundColor ?? theme.paperColor,
          strokeColor: theme.inkColor,
          createPrimitive: () => SketchyPrimitive.roundedRectangle(
            cornerRadius: theme.borderRadius,
            fill: SketchyFill.none,
          ),
          child: appBarContent,
        ),
      );
    },
  );
}
