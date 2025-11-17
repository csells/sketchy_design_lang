// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';
import 'package:wired_elements/wired_elements.dart';

SketchyThemeData _resolveSketchyTheme(SketchyColorMode mode, bool isDark) {
  final base = SketchyThemeData.fromMode(mode);
  if (!isDark) return base;
  final swappedColors = base.colors.copyWith(
    primary: base.colors.secondary,
    secondary: base.colors.primary,
    paper: SketchyPalette.charcoal,
    ink: SketchyPalette.white,
  );
  return base.copyWith(colors: swappedColors);
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
    final sketchyTheme = _resolveSketchyTheme(_activePalette.mode, _isDark);
    final materialTheme = _materialThemeFromSketchy(sketchyTheme, _isDark);

    return MaterialApp(
      title: 'Sketchy Design System',
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      home: SketchyDesignSystemPage(
        palette: _activePalette,
        palettes: _palettes,
        isDark: _isDark,
        onThemeChanged: (id) {
          setState(() => _activePaletteId = id);
        },
        onToggleDarkMode: () {
          setState(() => _isDark = !_isDark);
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
    super.key,
  });

  final PaletteOption palette;
  final List<PaletteOption> palettes;
  final bool isDark;
  final VoidCallback onToggleDarkMode;
  final ValueChanged<String> onThemeChanged;

  @override
  State<SketchyDesignSystemPage> createState() =>
      _SketchyDesignSystemPageState();
}

class _SketchyDesignSystemPageState extends State<SketchyDesignSystemPage>
    with TickerProviderStateMixin {
  // State for the "sketchy" components
  String _selectedRadio = 'Lafayette';
  double _sliderValue = 0.2;
  double _progressValue = 0.4;
  Timer? _progressTimer;
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
    _progressTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startProgress() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 150), (t) {
      setState(() {
        _progressValue += 0.02;
        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          t.cancel();
        }
      });
    });
  }

  void _stopProgress() {
    _progressTimer?.cancel();
  }

  void _resetProgress() {
    _progressTimer?.cancel();
    setState(() {
      _progressValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Sketchy Design System')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
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
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, PaletteOption palette) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Mascot
      Image.asset('assets/images/sketchy_mascot.png', width: 96, height: 96),
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
          final previewColors = _resolveSketchyTheme(option.mode, false).colors;
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Text(
          'Mode',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        WiredButton(
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
        WiredButton(
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

    final left = <Widget>[];
    final right = <Widget>[];

    for (var i = 0; i < cards.length; i++) {
      final target = i.isEven ? left : right;
      if (target.isNotEmpty) {
        target.add(const SizedBox(height: 24));
      }
      target.add(cards[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: 24),
        Expanded(child: Column(children: right)),
      ],
    );
  }

  Widget _buildButtonsSection() => _sectionCard(
    title: 'Sketchy buttons',
    height: 230,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WiredButton(
          child: Text('Sketchy Button', style: _buttonLabelStyle(context)),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            WiredButton(
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
            WiredButton(
              child: Text(
                'Cancel',
                style: _buttonLabelStyle(
                  context,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        WiredButton(
          child: Text(
            'Long text button … hah',
            style: _buttonLabelStyle(
              context,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          onPressed: () {},
        ),
      ],
    ),
  );

  Widget _buildDividerSection() => _sectionCard(
    title: 'Sketchy divider',
    height: 320,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua. '
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco '
          'laboris nisi ut aliquip ex ea commodo consequat.',
          style: _bodyStyle(context),
        ),
        const SizedBox(height: 12),
        const WiredDivider(),
        const SizedBox(height: 12),
        Text(
          'Duis aute irure dolor in reprehenderit in voluptate velit esse '
          'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
          'cupidatat non proident, sunt in culpa qui officia deserunt '
          'mollit anim id est laborum.',
          style: _bodyStyle(context),
        ),
      ],
    ),
  );

  Widget _buildInputsSection() => _sectionCard(
    title: 'Sketchy input',
    height: 280,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        WiredInput(
          controller: _nameController,
          hintText: 'Hello sketchy input',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        Text('User Email', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        WiredInput(
          controller: _emailController,
          hintText: 'Please enter user email',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        Text('Your age', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        WiredInput(
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
    height: 180,
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
      WiredRadio<String>(
        value: label,
        groupValue: _selectedRadio,
        onChanged: (value) {
          if (value == null) return false;
          setState(() => _selectedRadio = value);
          return true;
        },
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: _bodyStyle(context))),
    ],
  );

  Widget _buildSliderSection() => _sectionCard(
    title: 'Sketchy slider',
    height: 160,
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
        WiredSlider(
          value: _sliderValue,
          onChanged: (newValue) {
            setState(() => _sliderValue = newValue.clamp(0.0, 1.0));
            return true;
          },
        ),
      ],
    ),
  );

  Widget _buildProgressSection() => _sectionCard(
    title: 'Sketchy progress',
    height: 180,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WiredProgress(controller: _progressController, value: _progressValue),
        const SizedBox(height: 12),
        Row(
          children: [
            WiredButton(
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
            WiredButton(
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
            WiredButton(
              onPressed: _resetProgress,
              child: Text(
                'Reset',
                style: _buttonLabelStyle(
                  context,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildCalendarSection() => _sectionCard(
    title: 'Sketchy calendar',
    height: 350,
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
          height: 260,
          child: WiredCalendar(
            selected:
                '${_selectedDate.year}'
                '${_selectedDate.month.toString().padLeft(2, '0')}'
                '${_selectedDate.day.toString().padLeft(2, '0')}',
            onSelected: (dateStr) {
              // Parse YYYYMMDD format
              final year = int.parse(dateStr.substring(0, 4));
              final month = int.parse(dateStr.substring(4, 6));
              final day = int.parse(dateStr.substring(6, 8));
              setState(() => _selectedDate = DateTime(year, month, day));
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildCheckboxSection() => _sectionCard(
    title: 'Sketchy checkbox',
    height: 210,
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
    height: 180,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _notificationsOn ? 'Notifications enabled' : 'Notifications paused',
          style: _fieldLabelStyle(context),
        ),
        const SizedBox(height: 12),
        WiredToggle(
          value: _notificationsOn,
          onChange: (value) {
            setState(() => _notificationsOn = value);
            return true;
          },
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
    height: 210,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cadence', style: _fieldLabelStyle(context)),
        const SizedBox(height: 8),
        WiredCombo(
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
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dialogs keep the same rough frame and Comic Shanns tone.',
          style: _bodyStyle(context),
        ),
        const SizedBox(height: 12),
        WiredButton(
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
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return WiredCard(
      height: height ?? 250,
      fill: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: _bodyStyle(context, color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
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

  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? helper,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      WiredCheckbox(
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
          child: WiredDialog(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rough dialog',
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
                  child: WiredButton(
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
