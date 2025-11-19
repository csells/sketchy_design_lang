import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/icons.dart';
import '../widgets/sketchy_frame.dart';
import '../widgets/value_sync_mixin.dart';

/// A item for [SketchyCombo].
class SketchyComboItem<T> {
  /// Creates an item for a combo box.
  const SketchyComboItem({required this.value, required this.child});

  /// The value to return if the user selects this item.
  final T value;

  /// The widget to display for this item.
  final Widget child;
}

/// Sketchy combo box.
///
/// Usage:
/// ```dart
/// SketchyCombo(
///   value: 'One',
///   items: ['One', 'Two', 'Free', 'Four']
/// 	  .map<SketchyComboItem<String>>((dynamic value) {
/// 	return SketchyComboItem<String>(
/// 	  value: value,
/// 	  child: Padding(
/// 		padding: EdgeInsets.only(left: 5.0),
/// 		child: Text(value),
/// 	  ),
/// 	);
///   }).toList(),
///   onChanged: (value) {
/// 	print('$value');
///   },
/// ),
/// ```
class SketchyCombo<T> extends StatefulWidget {
  /// Creates a combo box backed by [items] with an optional selected [value].
  const SketchyCombo({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
  }) : assert(items.length > 0, 'items must not be empty');

  /// The selected value for combo.
  final T? value;

  /// The selection items for combo.
  final List<SketchyComboItem<T>> items;

  /// Called when the combo selected value changed.
  final ValueChanged<T?>? onChanged;

  @override
  State<SketchyCombo<T>> createState() => _SketchyComboState<T>();
}

class _SketchyComboState<T> extends State<SketchyCombo<T>>
    with ValueSyncMixin<T?, SketchyCombo<T>> {
  final double _height = 56;

  @override
  T? get widgetValue => widget.value;

  @override
  T? getOldWidgetValue(SketchyCombo<T> oldWidget) => oldWidget.value;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) {
          final selectedItem = widget.items.firstWhere(
            (item) => item.value == value,
            orElse: () => widget.items.first,
          );

          return GestureDetector(
            onTap: () => _showPopup(theme),
            child: SizedBox(
              height: _height,
              child: Stack(
                children: [
                  SketchyFrame(
                    height: _height,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    fill: SketchyFill.none,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: selectedItem.child,
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: (_height - 20) / 2,
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: const SketchyIcon(icon: SketchyIcons.chevronRight),
                    ),
                  ),
                ],
              ),
            ),
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
                  fillColor: theme.colors.paper,
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
                              child: item.child,
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
