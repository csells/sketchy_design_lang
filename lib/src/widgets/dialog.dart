import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';

const _kDialogMinWidth = 280.0;
const _kDialogMaxWidth = 560.0;
const _kDialogMargin = 24.0;

/// Sketchy dialog.
class Dialog extends StatelessWidget {
  /// Builds a sketchy-styled dialog containing [child].
  const Dialog({
    super.key,
    this.child,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding = const EdgeInsets.all(24),
    this.clipBehavior = Clip.none,
    this.shape,
    this.alignment,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The background color of the surface of this Dialog.
  final Color? backgroundColor;

  /// The z-coordinate of this Dialog. (Unused)
  final double? elevation;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the screen.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the screen.
  final Curve insetAnimationCurve;

  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the dialog.
  final EdgeInsets? insetPadding;

  /// Controls how the contents of the dialog are clipped (or not) to the given
  /// [shape].
  final Clip clipBehavior;

  /// The shape of this dialog's border. (Unused)
  final ShapeBorder? shape;

  /// The alignment of the dialog.
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final mediaQuery = MediaQuery.of(context);
      final horizontalMargin = insetPadding?.horizontal ?? _kDialogMargin * 2;
      final verticalMargin = insetPadding?.vertical ?? _kDialogMargin * 2;

      final viewWidth = (mediaQuery.size.width - horizontalMargin).clamp(
        0.0,
        double.infinity,
      );
      final safeWidth = viewWidth == 0 ? mediaQuery.size.width : viewWidth;
      final minWidth = math.min(_kDialogMinWidth, safeWidth);
      final maxWidth = math.max(
        minWidth,
        math.min(_kDialogMaxWidth, safeWidth),
      );
      final availableHeight = mediaQuery.size.height - verticalMargin;
      final maxHeight = availableHeight > 0
          ? availableHeight
          : mediaQuery.size.height;

      final widthConstraints = BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
      );

      return AnimatedPadding(
        duration: insetAnimationDuration,
        curve: insetAnimationCurve,
        padding:
            mediaQuery.viewInsets +
            (insetPadding ??
                const EdgeInsets.symmetric(
                  horizontal: _kDialogMargin,
                  vertical: _kDialogMargin,
                )),
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: widthConstraints,
                child: ClipRect(
                  clipBehavior: clipBehavior,
                  child: SketchyFrame(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    cornerRadius: 0,
                    fill: SketchyFill.solid,
                    fillColor: backgroundColor ?? theme.paperColor,
                    strokeColor: theme.borderColor,
                    strokeWidth: theme.strokeWidth,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// A Material Design alert dialog.
class AlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  const AlertDialog({
    super.key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
    this.contentTextStyle,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.all(24),
    this.clipBehavior = Clip.none,
    this.shape,
    this.alignment,
    this.scrollable = false,
    this.icon,
    this.iconPadding,
    this.iconColor,
  });

  /// An optional icon to display at the top of the dialog.
  final Widget? icon;

  /// Padding around the icon.
  final EdgeInsetsGeometry? iconPadding;

  /// Color for the icon.
  final Color? iconColor;

  /// The title of the dialog.
  final Widget? title;

  /// Padding around the title.
  final EdgeInsetsGeometry? titlePadding;

  /// Style for the title text.
  final TextStyle? titleTextStyle;

  /// The content of the dialog.
  final Widget? content;

  /// Padding around the content.
  final EdgeInsetsGeometry contentPadding;

  /// Style for the content text.
  final TextStyle? contentTextStyle;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  final List<Widget>? actions;

  /// Padding around the actions.
  final EdgeInsetsGeometry? actionsPadding;

  /// Defines the horizontal layout of the [actions].
  final MainAxisAlignment? actionsAlignment;

  /// Defines the horizontal layout of the actions when they overflow.
  final OverflowBarAlignment? actionsOverflowAlignment;

  /// The vertical direction of the actions when they overflow.
  final VerticalDirection? actionsOverflowDirection;

  /// The spacing between actions when they overflow.
  final double? actionsOverflowButtonSpacing;

  /// Padding for the buttons.
  final EdgeInsetsGeometry? buttonPadding;

  /// The background color of the surface of this Dialog.
  final Color? backgroundColor;

  /// The z-coordinate of this Dialog.
  final double? elevation;

  /// The color of the shadow.
  final Color? shadowColor;

  /// The color of the surface tint.
  final Color? surfaceTintColor;

  /// The semantic label of the dialog.
  final String? semanticLabel;

  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the dialog.
  final EdgeInsets insetPadding;

  /// Controls how the contents of the dialog are clipped (or not) to the given
  /// [shape].
  final Clip clipBehavior;

  /// The shape of this dialog's border.
  final ShapeBorder? shape;

  /// The alignment of the dialog.
  final AlignmentGeometry? alignment;

  /// Whether the content of the dialog is scrollable.
  final bool scrollable;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: backgroundColor,
    elevation: elevation,
    insetPadding: insetPadding,
    clipBehavior: clipBehavior,
    shape: shape,
    alignment: alignment,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (icon != null) ...[
          Padding(
            padding: iconPadding ?? const EdgeInsets.only(bottom: 16),
            child: IconTheme(
              data: IconThemeData(color: iconColor),
              child: icon!,
            ),
          ),
        ],
        if (title != null)
          Padding(
            padding: titlePadding ?? const EdgeInsets.only(bottom: 16),
            child: DefaultTextStyle(
              style:
                  titleTextStyle ??
                  SketchyTheme.of(
                    context,
                  ).typography.title.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              child: title!,
            ),
          ),
        if (content != null)
          Padding(
            padding: contentPadding,
            child: DefaultTextStyle(
              style:
                  contentTextStyle ?? SketchyTheme.of(context).typography.body,
              child: content!,
            ),
          ),
        if (actions != null)
          Padding(
            padding: actionsPadding ?? EdgeInsets.zero,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: actions!,
            ),
          ),
      ],
    ),
  );
}
