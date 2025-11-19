import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';
import 'surface.dart';
import 'text.dart';

/// Segmented control used to switch between sections.
class SketchyTabs extends StatelessWidget {
  /// Creates a new tab bar with the provided labels.
  const SketchyTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.textCase,
    super.key,
  });

  /// Tab labels.
  final List<String> tabs;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback invoked when a tab is selected.
  final ValueChanged<int> onChanged;

  /// Text casing transformation. If null, uses theTextCasing
  final TextCase? textCase;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final typography = SketchyTypography.of(context);

    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          GestureDetector(
            onTap: () => onChanged(i),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SketchySurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                fillColor: i == selectedIndex
                    ? theme.colors.secondary
                    : theme.colors.paper,
                strokeColor: theme.colors.ink,
                createPrimitive: () => SketchyPrimitive.roundedRectangle(
                  cornerRadius: theme.borderRadius,
                  fill: i == selectedIndex
                      ? SketchyFill.solid
                      : SketchyFill.none,
                ),
                child: SketchyText(
                  tabs[i],
                  textCase: textCase,
                  style: typography.body.copyWith(
                    fontWeight: i == selectedIndex
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
