// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

const Map<String, String> _fontOptions = <String, String>{
  'Comic Shanns': 'ComicShanns',
  'Excalifont': 'Excalifont',
  'xkcd': 'XKCD',
};

SketchyThemeData _resolveSketchyTheme(
  SketchyColorMode mode,
  bool isDark,
  double roughness,
  String fontFamily,
) {
  final base = SketchyThemeData.fromMode(mode, roughness: roughness);
  var colors = base.colors;
  if (isDark) {
    colors = colors.copyWith(
      primary: colors.secondary,
      secondary: colors.primary,
    );
  }
  colors = colors.copyWith(ink: colors.primary, paper: colors.secondary);
  final typography = _applyFont(base.typography, fontFamily);
  return base.copyWith(colors: colors, typography: typography);
}

ThemeData _materialThemeFromSketchy(
  SketchyThemeData sketchyTheme,
  bool isDark,
) {
  final colors = sketchyTheme.colors;
  final brightness = isDark ? Brightness.dark : Brightness.light;
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ).copyWith(
        primary: colors.primary,
        onPrimary: colors.secondary,
        secondary: colors.secondary,
        onSecondary: colors.ink,
        surface: colors.paper,
        onSurface: colors.ink,
      );

  final textTheme = TextTheme(
    displayLarge: sketchyTheme.typography.headline.copyWith(color: colors.ink),
    titleLarge: sketchyTheme.typography.title.copyWith(color: colors.ink),
    bodyLarge: sketchyTheme.typography.body.copyWith(color: colors.ink),
    bodyMedium: sketchyTheme.typography.body.copyWith(color: colors.ink),
    bodySmall: sketchyTheme.typography.caption.copyWith(color: colors.ink),
    labelLarge: sketchyTheme.typography.label.copyWith(color: colors.ink),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: colors.paper,
    colorScheme: colorScheme,
    fontFamily: sketchyTheme.typography.body.fontFamily,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.primary,
      foregroundColor: colors.secondary,
      centerTitle: true,
      titleTextStyle: sketchyTheme.typography.title.copyWith(
        color: colors.secondary,
        fontSize: 24,
      ),
    ),
  );
}

SketchyTypographyData _applyFont(
  SketchyTypographyData base,
  String fontFamily,
) => base.copyWith(
  headline: base.headline.copyWith(fontFamily: fontFamily),
  title: base.title.copyWith(fontFamily: fontFamily),
  body: base.body.copyWith(fontFamily: fontFamily),
  caption: base.caption.copyWith(fontFamily: fontFamily),
  label: base.label.copyWith(fontFamily: fontFamily),
);

class PaletteOption {
  const PaletteOption({
    required this.id,
    required this.label,
    required this.mode,
  });

  final String id;
  final String label;
  final SketchyColorMode mode;
}

void main() {
  runApp(const SketchyApp());
}

class SketchyApp extends StatefulWidget {
  const SketchyApp({super.key});

  @override
  State<SketchyApp> createState() => _SketchyAppState();
}

class _SketchyAppState extends State<SketchyApp> {
  bool _isDark = false;
  String _activePaletteId = 'monochrome';
  double _roughness = 0.5;
  String _fontFamily = _fontOptions.values.first;

  static const List<PaletteOption> _palettes = <PaletteOption>[
    PaletteOption(
      id: 'monochrome',
      label: 'Monochrome',
      mode: SketchyColorMode.white,
    ),
    PaletteOption(id: 'red', label: 'Red', mode: SketchyColorMode.red),
    PaletteOption(id: 'orange', label: 'Orange', mode: SketchyColorMode.orange),
    PaletteOption(id: 'yellow', label: 'Yellow', mode: SketchyColorMode.yellow),
    PaletteOption(id: 'green', label: 'Green', mode: SketchyColorMode.green),
    PaletteOption(id: 'blue', label: 'Blue', mode: SketchyColorMode.blue),
    PaletteOption(id: 'indigo', label: 'Indigo', mode: SketchyColorMode.indigo),
    PaletteOption(id: 'violet', label: 'Violet', mode: SketchyColorMode.violet),
  ];

  PaletteOption get _activePalette =>
      _palettes.firstWhere((option) => option.id == _activePaletteId);

  @override
  Widget build(BuildContext context) {
    final sketchyTheme = _resolveSketchyTheme(
      _activePalette.mode,
      _isDark,
      _roughness,
      _fontFamily,
    );
    final materialTheme = _materialThemeFromSketchy(sketchyTheme, _isDark);

    return MaterialApp(
      title: 'Sketchy Design System',
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return SketchyTheme(
          data: sketchyTheme,
          child: DefaultTextStyle(
            style: sketchyTheme.typography.body.copyWith(
              color: sketchyTheme.colors.ink,
            ),
            child: content,
          ),
        );
      },
      home: SketchyDesignSystemPage(
        palette: _activePalette,
        palettes: _palettes,
        isDark: _isDark,
        roughness: _roughness,
        onThemeChanged: (id) {
          setState(() => _activePaletteId = id);
        },
        onToggleDarkMode: () {
          setState(() => _isDark = !_isDark);
        },
        onRoughnessChanged: (value) {
          setState(() => _roughness = value.clamp(0.0, 1.0));
        },
        fontFamily: _fontFamily,
        onFontChanged: (family) {
          setState(() => _fontFamily = family);
        },
      ),
    );
  }
}

class SketchyDesignSystemPage extends StatefulWidget {
  const SketchyDesignSystemPage({
    required this.palette,
    required this.palettes,
    required this.isDark,
    required this.onToggleDarkMode,
    required this.onThemeChanged,
    required this.roughness,
    required this.onRoughnessChanged,
    required this.fontFamily,
    required this.onFontChanged,
    super.key,
  });

  final PaletteOption palette;
  final List<PaletteOption> palettes;
  final bool isDark;
  final VoidCallback onToggleDarkMode;
  final ValueChanged<String> onThemeChanged;
  final double roughness;
  final ValueChanged<double> onRoughnessChanged;
  final String fontFamily;
  final ValueChanged<String> onFontChanged;

  @override
  State<SketchyDesignSystemPage> createState() =>
      _SketchyDesignSystemPageState();
}

class _SketchyDesignSystemPageState extends State<SketchyDesignSystemPage>
    with TickerProviderStateMixin {
  static const double _cardWidth = 520;
  // State for the "sketchy" components
  String _selectedRadio = 'Lafayette';
  double _sliderValue = 0.2;
  DateTime _selectedDate = DateTime(2021, 7, 22);
  bool _newsletterOptIn = true;
  bool _mascotOptIn = false;
  bool _notificationsOn = true;
  String _selectedCadence = 'Weekly';
  static const List<String> _cadenceOptions = ['Daily', 'Weekly', 'Monthly'];

  // Controllers for wired elements
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startProgress() {
    _progressController
      ..stop()
      ..reset();
    unawaited(_progressController.forward());
  }

  void _stopProgress() {
    _progressController.stop();
  }

  void _resetProgress() {
    _progressController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Sketchy Design System')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(context, palette),
            const SizedBox(height: 24),
            _buildThemeRow(palette),
            const SizedBox(height: 24),
            _buildModeToggleRow(),
            const SizedBox(height: 32),
            _buildShowcaseBoard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, PaletteOption palette) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Tooltip(
        message: 'meh',
        textStyle: TextStyle(
          fontFamily: 'ComicShanns',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(
          'assets/images/sketchy_mascot.png',
          width: 96,
          height: 96,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sketchy',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'An xkcd-inspired design system powered by '
              'wired_elements + Comic Shanns',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Current theme: ${palette.label} • '
              'Mode: ${widget.isDark ? 'Dark' : 'Light'}',
              style: _mutedStyle(context),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildThemeRow(PaletteOption active) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Theme colors',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        'Primary row = light-mode primary • '
        'Secondary row = light-mode secondary\n'
        'In dark mode, primary and secondary swap roles.',
        style: _mutedStyle(context),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: widget.palettes.map((option) {
          final isActive = option.id == active.id;
          final previewColors = _resolveSketchyTheme(
            option.mode,
            false,
            0.5,
            widget.fontFamily,
          ).colors;
          return GestureDetector(
            onTap: () => widget.onThemeChanged(option.id),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _colorChip(previewColors.primary, isActive),
                const SizedBox(height: 4),
                _colorChip(
                  previewColors.secondary,
                  isActive,
                  stroke: true,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  option.id,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );

  Widget _colorChip(
    Color color,
    bool isActive, {
    bool stroke = false,
    double size = 26,
  }) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: stroke ? null : color,
      border: Border.all(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
  );

  Widget _buildModeToggleRow() {
    final colors = Theme.of(context).colorScheme;
    final isLightActive = !widget.isDark;
    final isDarkActive = widget.isDark;
    final modeLabel = Text(
      'Mode',
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
    final toggleButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SketchyButton(
          onPressed: isLightActive ? () {} : widget.onToggleDarkMode,
          child: Text(
            'Light',
            style: _buttonLabelStyle(
              context,
              color: isLightActive
                  ? colors.primary
                  : colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SketchyButton(
          onPressed: isDarkActive ? () {} : widget.onToggleDarkMode,
          child: Text(
            'Dark',
            style: _buttonLabelStyle(
              context,
              color: isDarkActive
                  ? colors.primary
                  : colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
    final roughControls = SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rough',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SketchySlider(
                  value: widget.roughness,
                  onChanged: (value) =>
                      widget.onRoughnessChanged(value.clamp(0.0, 1.0)),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: widget.fontFamily,
                items: _fontOptions.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(entry.key, style: _bodyStyle(context)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) widget.onFontChanged(value);
                },
              ),
            ],
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              modeLabel,
              const SizedBox(height: 8),
              toggleButtons,
              const SizedBox(height: 16),
              roughControls,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            modeLabel,
            const SizedBox(width: 12),
            toggleButtons,
            const SizedBox(width: 24),
            roughControls,
          ],
        );
      },
    );
  }

  Widget _buildShowcaseBoard() {
    final cards = <Widget>[
      _buildButtonsSection(),
      _buildDividerSection(),
      _buildInputsSection(),
      _buildRadioSection(),
      _buildSliderSection(),
      _buildProgressSection(),
      _buildCalendarSection(),
      _buildCheckboxSection(),
      _buildToggleSection(),
      _buildComboSection(),
      _buildDialogSection(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final cardWidth = math.min(_cardWidth, availableWidth);
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: cards
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        );
      },
    );
  }

  Widget _buildButtonsSection() => _sectionCard(
    title: 'Sketchy buttons',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyButton(
          child: Text('Sketchy Button', style: _buttonLabelStyle(context)),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SketchyButton(
              child: Text(
                'Submit',
                style: _buttonLabelStyle(
                  context,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            SketchyButton(
              child: Text(
                'Cancel',
                style: _buttonLabelStyle(context, color: Colors.grey.shade500),
              ),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        SketchyButton(
          child: Text(
            'Long text button … hah',
            style: _buttonLabelStyle(context),
          ),
          onPressed: () {},
        ),
      ],
    ),
  );

  Widget _buildDividerSection() => _sectionCard(
    title: 'Sketchy divider',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: _bodyStyle(context),
        ),
        const SizedBox(height: 12),
        const SketchyDivider(),
        const SizedBox(height: 12),
        Text(
          'Duis aute irure dolor in reprehenderit in voluptate velit esse '
          'cillum dolore eu fugiat nulla pariatur.',
          style: _bodyStyle(context),
        ),
      ],
    ),
  );

  Widget _buildInputsSection() => _sectionCard(
    title: 'Sketchy input',
    height: 340,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyTextInput(
          controller: _nameController,
          hintText: 'Hello sketchy input',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        Text('User Email', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyTextInput(
          controller: _emailController,
          hintText: 'Please enter user email',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        Text('Your age', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyTextInput(
          controller: _ageController,
          hintText: 'Your age please!',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
      ],
    ),
  );

  Widget _buildRadioSection() => _sectionCard(
    title: 'Sketchy radio',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioOption('Lafayette'),
        const SizedBox(height: 8),
        _buildRadioOption('Thomas Jefferson'),
      ],
    ),
  );

  Widget _buildRadioOption(String label) => Row(
    children: [
      SketchyRadio<String>(
        value: label,
        groupValue: _selectedRadio,
        onChanged: (value) {
          if (value == null) return;
          setState(() => _selectedRadio = value);
        },
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: _bodyStyle(context))),
    ],
  );

  Widget _buildSliderSection() => _sectionCard(
    title: 'Sketchy slider',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Value: ${(100 * _sliderValue).round()}',
          style: _fieldLabelStyle(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 8),
        SketchySlider(
          value: _sliderValue,
          onChanged: (newValue) =>
              setState(() => _sliderValue = newValue.clamp(0.0, 1.0)),
        ),
      ],
    ),
  );

  Widget _buildProgressSection() => _sectionCard(
    title: 'Sketchy progress',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyProgressBar(controller: _progressController, value: 0),
        const SizedBox(height: 12),
        Row(
          children: [
            SketchyButton(
              onPressed: _startProgress,
              child: Text(
                'Start',
                style: _buttonLabelStyle(
                  context,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SketchyButton(
              onPressed: _stopProgress,
              child: Text(
                'Stop',
                style: _buttonLabelStyle(
                  context,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SketchyButton(
              onPressed: _resetProgress,
              child: Text('Reset', style: _buttonLabelStyle(context)),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildCalendarSection() => _sectionCard(
    title: 'Sketchy calendar',
    height: 516,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedDate.year} – '
          '${_selectedDate.month.toString().padLeft(2, '0')} – '
          '${_selectedDate.day.toString().padLeft(2, '0')}',
          style: _fieldLabelStyle(context),
        ),
        const SizedBox(height: 8),
        // The Flutter wrapper's API mirrors the JS version fairly closely;
        // adjust attributes as needed once you wire it up.
        SizedBox(
          height: 385,
          child: SketchyCalendar(
            selected: _selectedDate,
            onSelected: (date) => setState(() => _selectedDate = date),
          ),
        ),
      ],
    ),
  );

  Widget _buildCheckboxSection() => _sectionCard(
    title: 'Sketchy checkbox',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxOption(
          label: 'Send me sketchy release notes',
          helper: 'Early builds + easter eggs',
          value: _newsletterOptIn,
          onChanged: (checked) => _newsletterOptIn = checked,
        ),
        const SizedBox(height: 12),
        _buildCheckboxOption(
          label: 'Include mascot doodles',
          helper: 'The yellow face has strong opinions.',
          value: _mascotOptIn,
          onChanged: (checked) => _mascotOptIn = checked,
        ),
      ],
    ),
  );

  Widget _buildToggleSection() => _sectionCard(
    title: 'Sketchy toggle',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _notificationsOn ? 'Notifications enabled' : 'Notifications paused',
          style: _fieldLabelStyle(context),
        ),
        const SizedBox(height: 12),
        SketchyToggle(
          value: _notificationsOn,
          onChanged: (value) => setState(() => _notificationsOn = value),
        ),
        const SizedBox(height: 8),
        Text(
          'Use toggles for quick binary actions—no material switch required.',
          style: _mutedStyle(context),
        ),
      ],
    ),
  );

  Widget _buildComboSection() => _sectionCard(
    title: 'Sketchy combo',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cadence', style: _fieldLabelStyle(context)),
        const SizedBox(height: 8),
        SketchyCombo(
          value: _selectedCadence,
          items: _cadenceOptions
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(option, style: _bodyStyle(context)),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value is String) {
              setState(() => _selectedCadence = value);
            }
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Currently sending a $_selectedCadence digest.',
          style: _mutedStyle(context),
        ),
      ],
    ),
  );

  Widget _buildDialogSection() => _sectionCard(
    title: 'Sketchy dialog',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dialogs keep the same rough frame and Comic Shanns tone.',
          style: _bodyStyle(context),
        ),
        const SizedBox(height: 12),
        SketchyButton(
          onPressed: _showSketchyDialog,
          child: Text(
            'Open dialog',
            style: _buttonLabelStyle(
              context,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _sectionCard({
    required String title,
    required Widget child,
    double? height,
  }) {
    final sketchy = SketchyTheme.of(context);
    final borderColor = _cardBorderColor(sketchy);
    final fillColor = widget.isDark
        ? Color.lerp(sketchy.colors.paper, sketchy.colors.secondary, 0.2)!
        : sketchy.colors.paper;
    final textColor = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: double.infinity,
      child: SketchySurface(
        height: height ?? 250,
        padding: const EdgeInsets.all(16),
        strokeColor: borderColor,
        fillColor: fillColor,
        child: DefaultTextStyle(
          style: _bodyStyle(context, color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Color _cardBorderColor(SketchyThemeData sketchy) => sketchy.colors.primary;

  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? helper,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SketchyCheckbox(
        value: value,
        onChanged: (checked) {
          if (checked == null) return;
          setState(() => onChanged(checked));
        },
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _bodyStyle(context)),
            if (helper != null) ...[
              const SizedBox(height: 4),
              Text(helper, style: _mutedStyle(context)),
            ],
          ],
        ),
      ),
    ],
  );

  Future<void> _showSketchyDialog() async {
    final colors = Theme.of(context).colorScheme;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Center(
        child: SizedBox(
          width: 420,
          height: 340,
          child: SketchyDialog(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sketchy dialog title',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Dialogs use the same sketchy primitives—double outlines, '
                  'Comic Shanns copy, and playful spacing.',
                  style: _bodyStyle(context),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: SketchyButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      'Got it',
                      style: _buttonLabelStyle(context, color: colors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _bodyStyle(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final base =
        theme.textTheme.bodyMedium ??
        const TextStyle(fontFamily: 'ComicShanns', fontSize: 16);
    return base.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  TextStyle _mutedStyle(BuildContext context) => _bodyStyle(
    context,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  );

  TextStyle _fieldLabelStyle(BuildContext context) => _bodyStyle(
    context,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  TextStyle _buttonLabelStyle(BuildContext context, {Color? color}) =>
      _bodyStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      );
}
