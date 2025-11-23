import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';
import 'value_sync_mixin.dart';

/// A item for [DropdownButton].
class DropdownMenuItem<T> {
  /// Creates an item for a combo box.
  const DropdownMenuItem({required this.value, required this.child});

  /// The value to return if the user selects this item.
  final T value;

  /// The widget to display for this item.
  final Widget child;
}

/// Sketchy combo box.
class DropdownButton<T> extends StatefulWidget {
  /// Creates a combo box backed by [items] with an optional selected [value].
  const DropdownButton({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
  }) : assert(items.length > 0, 'items must not be empty');

  /// The selected value for combo.
  final T? value;

  /// The selection items for combo.
  final List<DropdownMenuItem<T>> items;

  /// Called when the combo selected value changed.
  final ValueChanged<T?>? onChanged;

  /// A placeholder widget that is displayed by the dropdown button.
  final Widget? hint;

  /// A message to display when the dropdown is disabled.
  final Widget? disabledHint;

  /// Called when the dropdown button is tapped.
  final VoidCallback? onTap;

  /// The z-coordinate at which to place the menu when open. (Unused)
  final int elevation;

  /// The text style to use for text in the dropdown button.
  final TextStyle? style;

  /// The widget to use for drawing the drop-down button's underline. (Unused)
  final Widget? underline;

  /// The widget to use for the drop-down button's icon.
  final Widget? icon;

  /// The color of any [Icon] descendant of [icon] if this button is disabled.
  final Color? iconDisabledColor;

  /// The color of any [Icon] descendant of [icon] if this button is enabled.
  final Color? iconEnabledColor;

  /// The size to use for the drop-down button's down arrow icon button.
  final double iconSize;

  /// Reduce the button's height.
  final bool isDense;

  /// Set the dropdown's inner contents to horizontally fill its parent.
  final bool isExpanded;

  /// The height of the dropdown menu items.
  final double? itemHeight;

  /// The color for the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// True if this widget will be selected as the initial focus when no other
  /// node in its scope is currently focused.
  final bool autofocus;

  /// The background color of the dropdown.
  final Color? dropdownColor;

  /// The maximum height of the menu.
  final double? menuMaxHeight;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// Defines how the hint or the selected item is positioned within the button.
  final AlignmentGeometry alignment;

  /// The border radius of the dropdown menu.
  final BorderRadius? borderRadius;

  /// Padding around the visible button's content.
  final EdgeInsetsGeometry? padding;

  /// The minimum height of the interactive dimension.
  static const double kMinInteractiveDimension = 48;

  @override
  State<DropdownButton<T>> createState() => _DropdownButtonState<T>();
}

class _DropdownButtonState<T> extends State<DropdownButton<T>>
    with ValueSyncMixin<T?, DropdownButton<T>> {
  final double _height = 56;

  @override
  T? get widgetValue => widget.value;

  @override
  T? getOldWidgetValue(DropdownButton<T> oldWidget) => oldWidget.value;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == value,
        orElse: () => widget.items.first,
      );

      final child = Stack(
        children: [
          SketchyFrame(
            height: _height,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            fill: SketchyFill.none,
            child: Align(
              alignment: widget.alignment,
              child: DefaultTextStyle(
                style:
                    widget.style ??
                    theme.typography.body.copyWith(color: theme.inkColor),
                child: selectedItem.child,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: (_height - 20) / 2,
            child: Transform.rotate(
              angle: math.pi / 2,
              child: SizedBox(
                width: 20,
                height: 20,
                child:
                    widget.icon ??
                    CustomPaint(
                      painter: _SketchyChevronPainter(
                        color: widget.onChanged == null
                            ? (widget.iconDisabledColor ??
                                  theme.disabledTextColor)
                            : (widget.iconEnabledColor ?? theme.inkColor),
                      ),
                    ),
              ),
            ),
          ),
        ],
      );

      return GestureDetector(
        onTap: () {
          widget.onTap?.call();
          if (widget.onChanged != null) {
            _showPopup(theme);
          }
        },
        child: widget.isExpanded
            ? SizedBox(height: _height, child: child)
            : SizedBox(
                height: _height,
                width: 200,
                child: child,
              ), // Default width if not expanded
      );
    },
  );

  void _showPopup(SketchyThemeData theme) {
    final box = context.findRenderObject()! as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;

    unawaited(
      showGeneralDialog(
        context: context,
        barrierColor: const Color(0x00000000),
        barrierDismissible: true,
        barrierLabel: 'Dismiss',
        pageBuilder: (context, animation, secondaryAnimation) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: position.dx,
              top: position.dy + size.height,
            ),
            child: SizedBox(
              width: size.width,
              child: ClipRect(
                child: SketchyFrame(
                  alignment: null,
                  cornerRadius: 0,
                  fill: SketchyFill.solid,
                  fillColor: widget.dropdownColor ?? theme.paperColor,
                  strokeColor: theme.borderColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.items
                        .map(
                          (item) => GestureDetector(
                            onTap: () {
                              updateValue(item.value);
                              widget.onChanged?.call(item.value);
                              Navigator.of(context).pop();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: DefaultTextStyle(
                                style:
                                    widget.style ??
                                    theme.typography.body.copyWith(
                                      color: theme.inkColor,
                                    ),
                                child: item.child,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SketchyChevronPainter extends CustomPainter {
  _SketchyChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final generator = SketchyGenerator.createGenerator(seed: 2);

    final drawable = generator.linearPath([
      PointD(4, 4),
      PointD(size.width - 4, size.height / 2),
      PointD(4, size.height - 4),
    ]);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRough(drawable, paint, paint);
  }

  @override
  bool shouldRepaint(_SketchyChevronPainter oldDelegate) =>
      oldDelegate.color != color;
}
