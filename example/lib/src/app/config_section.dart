import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/theme_utils.dart';

class ConfigSection extends StatelessWidget {
  const ConfigSection({
    required this.activeTheme,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onThemeChanged,
    required this.roughness,
    required this.onRoughnessChanged,
    required this.fontFamily,
    required this.onFontChanged,
    required this.textCase,
    required this.onTitleCasingChanged,
    super.key,
  });

  final SketchyThemes activeTheme;
  final SketchyThemeMode themeMode;
  final ValueChanged<SketchyThemeMode> onThemeModeChanged;
  final ValueChanged<SketchyThemes> onThemeChanged;
  final double roughness;
  final ValueChanged<double> onRoughnessChanged;
  final String fontFamily;
  final ValueChanged<String> onFontChanged;
  final TextCase textCase;
  final ValueChanged<TextCase> onTitleCasingChanged;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          _ThemeColorsControl(
            active: activeTheme,
            fontFamily: fontFamily,
            onThemeChanged: onThemeChanged,
          ),
          ..._buildSettingsControls(theme),
        ],
      ),
    ),
  );

  List<Widget> _buildSettingsControls(SketchyThemeData theme) {
    final labelStyle = theme.typography.label.copyWith(
      fontWeight: FontWeight.bold,
    );

    Widget modeButton(String label, SketchyThemeMode mode) {
      final isActive = themeMode == mode;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: OutlinedButton(
          onPressed: isActive ? null : () => onThemeModeChanged(mode),
          child: Text(
            label,
            style: labelStyle.copyWith(
              color: isActive
                  ? theme.primaryColor
                  : theme.inkColor.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return [
      _ControlGroup(
        theme,
        label: 'Mode',
        width: 160,
        child: Row(
          children: [
            modeButton('Light', SketchyThemeMode.light),
            modeButton('Dark', SketchyThemeMode.dark),
          ],
        ),
      ),
      _ControlGroup(
        theme,
        label: 'Roughness',
        width: 240,
        child: Slider(
          value: roughness,
          onChanged: (value) => onRoughnessChanged(value.clamp(0.0, 1.0)),
        ),
      ),
      _ControlGroup(
        theme,
        label: 'Font',
        width: 240,
        child: DropdownButton<String>(
          value: fontFamily,
          items: fontOptions.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key, style: theme.typography.body),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onFontChanged(value);
          },
        ),
      ),
      _ControlGroup(
        theme,
        label: 'Title Casing',
        width: 240,
        child: DropdownButton<TextCase>(
          value: textCase,
          items: TextCase.values
              .map(
                (casing) => DropdownMenuItem<TextCase>(
                  value: casing,
                  child: Text(
                    textCaseLabel(casing),
                    style: theme.typography.body,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onTitleCasingChanged(value);
          },
        ),
      ),
    ];
  }
}

class _ControlGroup extends StatelessWidget {
  const _ControlGroup(
    this.theme, {
    required this.label,
    required this.child,
    this.width,
  });

  final SketchyThemeData theme;
  final String label;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.typography.title.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );

    if (width != null) {
      return SizedBox(width: width, child: content);
    }
    return content;
  }
}

class _ThemeColorsControl extends StatelessWidget {
  const _ThemeColorsControl({
    required this.active,
    required this.fontFamily,
    required this.onThemeChanged,
  });

  final SketchyThemes active;
  final String fontFamily;
  final ValueChanged<SketchyThemes> onThemeChanged;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => _ControlGroup(
      theme,
      label: 'Theme Colors',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: SketchyThemes.values.map((option) {
          final isActive = option == active;
          final previewTheme = resolveSketchyTheme(
            theme: option,
            roughness: 0.5,
            fontFamily: fontFamily,
            textCase: TextCase.none,
            mode: SketchyThemeMode.light,
          );

          return GestureDetector(
            onTap: () => onThemeChanged(option),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ColorChip(
                  color: previewTheme.primaryColor,
                  isActive: isActive,
                ),
                const SizedBox(height: 4),
                _ColorChip(
                  color: previewTheme.secondaryColor,
                  isActive: isActive,
                  stroke: true,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  option.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.isActive,
    this.stroke = false,
    this.size = 26,
  });

  final Color color;
  final bool isActive;
  final bool stroke;
  final double size;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: stroke ? null : color,
        border: Border.all(
          color: isActive
              ? theme.primaryColor
              : theme.inkColor.withValues(alpha: 0.4),
          width: isActive ? 2.4 : 1.4,
        ),
        shape: BoxShape.circle,
      ),
      child: stroke
          ? Center(
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            )
          : null,
    ),
  );
}
