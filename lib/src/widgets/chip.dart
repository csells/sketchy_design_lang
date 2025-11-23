import 'package:flutter/material.dart'
    show MaterialTapTargetSize, VisualDensity;
import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';
import 'text.dart' as sketchy;

/// Visual tones supported by [Chip].
enum SketchyChipTone {
  /// Primary accent tone.
  accent,

  /// Neutral ink tone.
  neutral,
}

/// A material design chip.
class Chip extends StatelessWidget {
  /// Creates a chip.
  const Chip({
    required this.label,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.labelStyle,
    this.labelPadding,
    this.deleteIconColor,
    this.deleteButtonTooltipMessage,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    super.key,
    // Sketchy specifics
    this.tone = SketchyChipTone.neutral,
    this.textCase,
    this.fillStyle,
    this.compact = false,
  });

  /// The primary content of the chip.
  final Widget label;

  /// A widget displayed before the label.
  final Widget? avatar;

  /// The icon displayed when [onDeleted] is set.
  final Widget? deleteIcon;

  /// Called when the delete icon is pressed.
  final VoidCallback? onDeleted;

  /// The style to be applied to the chip's label.
  final TextStyle? labelStyle;

  /// The padding around the label widget.
  final EdgeInsetsGeometry? labelPadding;

  /// The color of the delete icon.
  final Color? deleteIconColor;

  /// Tooltip string to be used for the delete button.
  final String? deleteButtonTooltipMessage;

  /// The color and weight of the chip's outline.
  final BorderSide? side;

  /// The shape of the chip.
  final OutlinedBorder? shape;

  /// Content clip behavior.
  final Clip clipBehavior;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Background color.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Visual density.
  final VisualDensity? visualDensity;

  /// Tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Elevation.
  final double? elevation;

  /// Shadow color.
  final Color? shadowColor;

  /// Surface tint color.
  final Color? surfaceTintColor;

  /// Icon theme.
  final IconThemeData? iconTheme;

  // Sketchy specifics
  /// Visual tone applied to fill/ink accents.
  final SketchyChipTone tone;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  /// Optional override for the interior fill style.
  final SketchyFill? fillStyle;

  /// Uses smaller typography + padding when true.
  final bool compact;

  @override
  Widget build(BuildContext context) => _SketchyChipImpl(
    label: label,
    avatar: avatar,
    onPressed: null,
    selected: false,
    compact: compact,
    filled: false, // Chips are usually outlined or lightly filled in Material
    tone: tone,
    textCase: textCase,
    fillStyle: fillStyle,
    backgroundColor: backgroundColor,
    labelStyle: labelStyle,
    padding: padding,
  );
}

/// A material design action chip.
class ActionChip extends StatelessWidget {
  /// Creates an action chip.
  const ActionChip({
    required this.label,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.onPressed,
    this.pressElevation,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    super.key,
    // Sketchy specifics
    this.tone = SketchyChipTone.neutral,
    this.textCase,
    this.fillStyle,
    this.compact = false,
  });

  /// The primary content of the chip.
  final Widget label;

  /// A widget displayed before the label.
  final Widget? avatar;

  /// The style to be applied to the chip's label.
  final TextStyle? labelStyle;

  /// The padding around the label widget.
  final EdgeInsetsGeometry? labelPadding;

  /// Called when the chip is pressed.
  final VoidCallback? onPressed;

  /// The amount of elevation for the chip when pressed.
  final double? pressElevation;

  /// Tooltip string to be used for the chip.
  final String? tooltip;

  /// The color and weight of the chip's outline.
  final BorderSide? side;

  /// The shape of the chip.
  final OutlinedBorder? shape;

  /// Content clip behavior.
  final Clip clipBehavior;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Background color.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Visual density.
  final VisualDensity? visualDensity;

  /// Tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Elevation.
  final double? elevation;

  /// Shadow color.
  final Color? shadowColor;

  /// Surface tint color.
  final Color? surfaceTintColor;

  /// Icon theme.
  final IconThemeData? iconTheme;

  // Sketchy specifics
  /// Visual tone applied to fill/ink accents.
  final SketchyChipTone tone;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  /// Optional override for the interior fill style.
  final SketchyFill? fillStyle;

  /// Uses smaller typography + padding when true.
  final bool compact;

  @override
  Widget build(BuildContext context) => _SketchyChipImpl(
    label: label,
    avatar: avatar,
    onPressed: onPressed,
    selected: false,
    compact: compact,
    filled: false,
    tone: tone,
    textCase: textCase,
    fillStyle: fillStyle,
    backgroundColor: backgroundColor,
    labelStyle: labelStyle,
    padding: padding,
  );
}

/// A material design choice chip.
class ChoiceChip extends StatelessWidget {
  /// Creates a choice chip.
  const ChoiceChip({
    required this.label,
    required this.selected,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.avatarBorder,
    super.key,
    // Sketchy specifics
    this.tone = SketchyChipTone.accent,
    this.textCase,
    this.fillStyle,
    this.compact = false,
  });

  /// The primary content of the chip.
  final Widget label;

  /// Whether or not this chip is selected.
  final bool selected;

  /// A widget displayed before the label.
  final Widget? avatar;

  /// The style to be applied to the chip's label.
  final TextStyle? labelStyle;

  /// The padding around the label widget.
  final EdgeInsetsGeometry? labelPadding;

  /// Called when the chip is selected.
  final ValueChanged<bool>? onSelected;

  /// The amount of elevation for the chip when pressed.
  final double? pressElevation;

  /// The color to use when the chip is selected.
  final Color? selectedColor;

  /// The color to use when the chip is disabled.
  final Color? disabledColor;

  /// Tooltip string to be used for the chip.
  final String? tooltip;

  /// The color and weight of the chip's outline.
  final BorderSide? side;

  /// The shape of the chip.
  final OutlinedBorder? shape;

  /// Content clip behavior.
  final Clip clipBehavior;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Background color.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Visual density.
  final VisualDensity? visualDensity;

  /// Tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Elevation.
  final double? elevation;

  /// Shadow color.
  final Color? shadowColor;

  /// Surface tint color.
  final Color? surfaceTintColor;

  /// Icon theme.
  final IconThemeData? iconTheme;

  /// The color of the shadow when the chip is selected.
  final Color? selectedShadowColor;

  /// The border shape for the avatar.
  final ShapeBorder? avatarBorder;

  // Sketchy specifics
  /// Visual tone applied to fill/ink accents.
  final SketchyChipTone tone;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  /// Optional override for the interior fill style.
  final SketchyFill? fillStyle;

  /// Uses smaller typography + padding when true.
  final bool compact;

  @override
  Widget build(BuildContext context) => _SketchyChipImpl(
    label: label,
    avatar: avatar,
    onPressed: onSelected != null ? () => onSelected!(!selected) : null,
    selected: selected,
    compact: compact,
    filled: selected,
    tone: tone,
    textCase: textCase,
    fillStyle: fillStyle,
    backgroundColor: backgroundColor,
    labelStyle: labelStyle,
    padding: padding,
  );
}

class _SketchyChipImpl extends StatelessWidget {
  const _SketchyChipImpl({
    required this.label,
    required this.onPressed,
    required this.selected,
    required this.compact,
    required this.filled,
    required this.tone,
    required this.fillStyle,
    this.avatar,
    this.textCase,
    this.backgroundColor,
    this.labelStyle,
    this.padding,
  });

  final Widget label;
  final VoidCallback? onPressed;
  final bool selected;
  final bool compact;
  final bool filled;
  final SketchyChipTone tone;
  final SketchyFill? fillStyle;
  final Widget? avatar;
  final TextCase? textCase;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;

  Color _toneColor(SketchyThemeData theme) => switch (tone) {
    SketchyChipTone.accent => theme.primaryColor,
    SketchyChipTone.neutral => theme.inkColor,
  };

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final toneColor = _toneColor(theme);
      final shouldFill = filled || selected;
      final effectivePadding =
          padding ??
          (compact
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 10));

      final textStyleBase = compact
          ? theme.typography.label
          : theme.typography.body;
      final effectiveTextStyle = (labelStyle ?? textStyleBase).copyWith(
        color: theme.inkColor,
        fontWeight: selected ? FontWeight.w700 : textStyleBase.fontWeight,
      );

      final effectiveFillColor = shouldFill
          ? (backgroundColor ??
                toneColor.withValues(alpha: compact ? 0.35 : 0.2))
          : (backgroundColor ?? theme.paperColor);

      final effectiveFill = shouldFill
          ? (fillStyle ?? SketchyFill.hachure)
          : SketchyFill.none;

      final content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[
            IconTheme(
              data: IconThemeData(
                size: compact ? 14 : 18,
                color: theme.inkColor,
              ),
              child: avatar!,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: DefaultTextStyle(
              style: effectiveTextStyle,
              child: label is sketchy.SketchyText && textCase != null
                  ? sketchy.SketchyText(
                      (label as sketchy.SketchyText).data,
                      textCase: textCase,
                    )
                  : label,
            ),
          ),
        ],
      );

      final surface = IntrinsicWidth(
        child: IntrinsicHeight(
          child: SketchySurface(
            padding: effectivePadding,
            fillColor: effectiveFillColor,
            strokeColor: theme.inkColor,
            createPrimitive: () => SketchyPrimitive.pill(fill: effectiveFill),
            child: content,
          ),
        ),
      );

      if (onPressed == null) return surface;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onPressed, child: surface),
      );
    },
  );
}
