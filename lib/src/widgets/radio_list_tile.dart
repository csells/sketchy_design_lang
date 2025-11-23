import 'package:flutter/material.dart' show ListTileControlAffinity;
import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'radio.dart';

/// A list tile with a radio button.
class RadioListTile<T> extends StatelessWidget {
  /// Creates a tile wrapping a [Radio].
  const RadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    super.key,
  });

  /// The value this radio button represents.
  final T value;

  /// The currently selected value for this group of radio buttons.
  final T? groupValue;

  /// Called when the user selects this radio button.
  final ValueChanged<T?>? onChanged;

  /// The primary content of the list tile.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// Whether this list tile is intended to display three lines of text.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  final bool? dense;

  /// A widget to display on the opposite side of the tile from the radio
  /// button.
  final Widget? secondary;

  /// Whether to render icons and text in the active color.
  ///
  /// The active color is determined by the theme.
  final bool selected;

  /// Where to place the control relative to the text.
  final ListTileControlAffinity controlAffinity;

  void _handleTap() {
    if (onChanged != null) {
      onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final control = Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      );

      final labelColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) title!,
          if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
        ],
      );

      Widget? leading;
      Widget? trailing;
      switch (controlAffinity) {
        case ListTileControlAffinity.leading:
          leading = control;
          trailing = secondary;
        case ListTileControlAffinity.trailing:
        case ListTileControlAffinity.platform:
          leading = secondary;
          trailing = control;
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged != null ? _handleTap : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 12)],
            Expanded(child: labelColumn),
            if (trailing != null) ...[const SizedBox(width: 12), trailing],
          ],
        ),
      );
    },
  );
}
