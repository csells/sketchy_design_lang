import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

const Map<String, String> _fontOptions = <String, String>{
  'Comic Shanns': 'ComicShanns',
  'Excalifont': 'Excalifont',
  'xkcd': 'XKCD',
};

SketchyThemeData _resolveSketchyTheme({
  required SketchyColorMode mode,
  required double roughness,
  required String fontFamily,
  required TextCase textCase,
}) {
  final data = SketchyThemeData.fromMode(
    mode,
    roughness: roughness,
    textCase: textCase,
  );

  return data.copyWith(
    typography: data.typography.copyWith(
      headline: data.typography.headline.copyWith(fontFamily: fontFamily),
      title: data.typography.title.copyWith(fontFamily: fontFamily),
      body: data.typography.body.copyWith(fontFamily: fontFamily),
      caption: data.typography.caption.copyWith(fontFamily: fontFamily),
      label: data.typography.label.copyWith(fontFamily: fontFamily),
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
  runApp(const SketchyDesignSystemApp());
}

class SketchyDesignSystemApp extends StatefulWidget {
  const SketchyDesignSystemApp({super.key});

  @override
  State<SketchyDesignSystemApp> createState() => _SketchyDesignSystemAppState();
}

class _SketchyDesignSystemAppState extends State<SketchyDesignSystemApp> {
  SketchyThemeMode _themeMode = SketchyThemeMode.system;
  String _activePaletteId = 'monochrome';
  double _roughness = 0.5;
  String _fontFamily = 'XKCD';
  TextCase _textCase = TextCase.allCaps;

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
  Widget build(BuildContext context) => SketchyApp(
    title: 'Sketchy Design System',
    theme: _resolveSketchyTheme(
      mode: _activePalette.mode,
      roughness: _roughness,
      fontFamily: _fontFamily,
      textCase: _textCase,
    ),
    themeMode: _themeMode,
    debugShowCheckedModeBanner: false,
    home: SketchyDesignSystemPage(
      palette: _activePalette,
      palettes: _palettes,
      themeMode: _themeMode,
      roughness: _roughness,
      onThemeChanged: (id) {
        setState(() => _activePaletteId = id);
      },
      onThemeModeChanged: (mode) {
        setState(() => _themeMode = mode);
      },
      onRoughnessChanged: (value) {
        setState(() => _roughness = value.clamp(0.0, 1.0));
      },
      fontFamily: _fontFamily,
      onFontChanged: (family) {
        setState(() => _fontFamily = family);
      },
      textCase: _textCase,
      onTitleCasingChanged: (casing) {
        setState(() => _textCase = casing);
      },
    ),
  );
}

class SketchyDesignSystemPage extends StatefulWidget {
  const SketchyDesignSystemPage({
    required this.palette,
    required this.palettes,
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

  final PaletteOption palette;
  final List<PaletteOption> palettes;
  final SketchyThemeMode themeMode;
  final ValueChanged<SketchyThemeMode> onThemeModeChanged;
  final ValueChanged<String> onThemeChanged;
  final double roughness;
  final ValueChanged<double> onRoughnessChanged;
  final String fontFamily;
  final ValueChanged<String> onFontChanged;
  final TextCase textCase;
  final ValueChanged<TextCase> onTitleCasingChanged;

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

  // Controllers for showcase widgets
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
    return SketchyScaffold(
      appBar: _buildHeroAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

  SketchyAppBar _buildHeroAppBar(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SketchyAppBar(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.all(16),
      leading: SketchyTooltip(
        message: 'meh.',
        preferBelow: true,
        child: SketchyFrame(
          child: Image.asset(
            'assets/images/sketchy_mascot.png',
            width: 96,
            height: 96,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Sketchy',
            style: theme.typography.headline.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SketchyText('''
A hand-drawn, xkcd-inspired design language for Flutter on mobile, desktop, and
web powered by the wired_elements code, the flutter_rough package and the
Comic Shanns font.
''', style: theme.typography.title.copyWith(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildThemeRow(PaletteOption active) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SketchyText('Theme colors', style: _titleStyle(context)),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: widget.palettes.map((option) {
          final isActive = option.id == active.id;
          final previewColors = _resolveSketchyTheme(
            mode: option.mode,
            roughness: 0.5,
            fontFamily: widget.fontFamily,
            textCase: TextCase.none,
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
                SketchyText(
                  option.label,
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
  }) {
    final theme = SketchyTheme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: stroke ? null : color,
        border: Border.all(
          color: isActive
              ? theme.colors.primary
              : theme.colors.ink.withValues(alpha: 0.4),
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
  }

  Widget _buildModeToggleRow() {
    final theme = SketchyTheme.of(context);
    final activeMode = widget.themeMode;
    final labelStyle = theme.typography.title.copyWith(
      fontWeight: FontWeight.bold,
    );

    Widget modeButton(String label, SketchyThemeMode mode) {
      final isActive = activeMode == mode;
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SketchyButton(
          onPressed: isActive ? null : () => widget.onThemeModeChanged(mode),
          child: SketchyText(
            label,
            style: _buttonLabelStyle(
              context,
              color: isActive
                  ? theme.colors.primary
                  : theme.colors.ink.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    Widget buildModeControls() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Mode', style: labelStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            modeButton('Light', SketchyThemeMode.light),
            modeButton('Dark', SketchyThemeMode.dark),
          ],
        ),
      ],
    );

    Widget buildRoughControls() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Rough', style: labelStyle),
        const SizedBox(height: 8),
        SketchySlider(
          value: widget.roughness,
          onChanged: (value) =>
              widget.onRoughnessChanged(value.clamp(0.0, 1.0)),
        ),
      ],
    );

    Widget buildFontControls() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Font', style: labelStyle),
        const SizedBox(height: 8),
        SketchyCombo<String>(
          value: widget.fontFamily,
          items: _fontOptions.entries
              .map(
                (entry) => SketchyComboItem<String>(
                  value: entry.value,
                  child: SketchyText(entry.key, style: _bodyStyle(context)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) widget.onFontChanged(value);
          },
        ),
      ],
    );

    Widget buildTitleCasingControls() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Title Casing', style: labelStyle),
        const SizedBox(height: 8),
        SketchyCombo<TextCase>(
          value: widget.textCase,
          items: TextCase.values
              .map(
                (casing) => SketchyComboItem<TextCase>(
                  value: casing,
                  child: SketchyText(
                    _textCaseLabel(casing),
                    style: _bodyStyle(context),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) widget.onTitleCasingChanged(value);
          },
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 960;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildModeControls(),
              const SizedBox(height: 16),
              buildRoughControls(),
              const SizedBox(height: 16),
              buildFontControls(),
              const SizedBox(height: 16),
              buildTitleCasingControls(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 200, child: buildModeControls()),
            const SizedBox(width: 24),
            SizedBox(width: 200, child: buildRoughControls()),
            const SizedBox(width: 24),
            SizedBox(width: 200, child: buildFontControls()),
            const SizedBox(width: 24),
            SizedBox(width: 200, child: buildTitleCasingControls()),
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

  Widget _buildButtonsSection() {
    final theme = SketchyTheme.of(context);
    return _sectionCard(
      title: 'Sketchy buttons',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyButton(
            child: SketchyText(
              'Sketchy Button',
              style: _buttonLabelStyle(context),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SketchyButton(
                child: SketchyText(
                  'Submit',
                  style: _buttonLabelStyle(
                    context,
                    color: theme.colors.primary,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              SketchyButton(
                child: SketchyText(
                  'Cancel',
                  style: _buttonLabelStyle(
                    context,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          SketchyButton(
            child: SketchyText(
              'Long text button … hah',
              style: _buttonLabelStyle(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDividerSection() => _sectionCard(
    title: 'Sketchy divider',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: _bodyStyle(context),
        ),
        const SizedBox(height: 12),
        const SketchyDivider(),
        const SizedBox(height: 12),
        SketchyText(
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
        SketchyText('Name', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyTextInput(
          controller: _nameController,
          hintText: 'Hello sketchy input',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        SketchyText('User Email', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyTextInput(
          controller: _emailController,
          hintText: 'Please enter user email',
          style: _bodyStyle(context),
          hintStyle: _mutedStyle(context),
        ),
        const SizedBox(height: 12),
        SketchyText('Your age', style: _fieldLabelStyle(context)),
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
      Expanded(child: SketchyText(label, style: _bodyStyle(context))),
    ],
  );

  Widget _buildSliderSection() {
    final theme = SketchyTheme.of(context);
    return _sectionCard(
      title: 'Sketchy slider',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Value: ${(100 * _sliderValue).round()}',
            style: _fieldLabelStyle(
              context,
            ).copyWith(color: theme.colors.secondary),
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
  }

  Widget _buildProgressSection() {
    final theme = SketchyTheme.of(context);
    return _sectionCard(
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
                child: SketchyText(
                  'Start',
                  style: _buttonLabelStyle(
                    context,
                    color: theme.colors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SketchyButton(
                onPressed: _stopProgress,
                child: SketchyText(
                  'Stop',
                  style: _buttonLabelStyle(
                    context,
                    color: const Color(0xFFB00020), // Error color
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SketchyButton(
                onPressed: _resetProgress,
                child: SketchyText('Reset', style: _buttonLabelStyle(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() => _sectionCard(
    title: 'Sketchy calendar',
    height: 516,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText(
          '${_selectedDate.year} – '
          '${_selectedDate.month.toString().padLeft(2, '0')} – '
          '${_selectedDate.day.toString().padLeft(2, '0')}',
          style: _fieldLabelStyle(context),
        ),
        const SizedBox(height: 8),
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
          label: 'Mascot mode',
          helper: 'More sketchy faces',
          value: _mascotOptIn,
          onChanged: (checked) => _mascotOptIn = checked,
        ),
      ],
    ),
  );

  Widget _buildCheckboxOption({
    required String label,
    required String helper,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SketchyCheckbox(
        value: value,
        onChanged: (val) => onChanged(val ?? false),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SketchyText(label, style: _bodyStyle(context)),
            SketchyText(helper, style: _mutedStyle(context)),
          ],
        ),
      ),
    ],
  );

  Widget _buildToggleSection() => _sectionCard(
    title: 'Sketchy toggle',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleOption(
          label: 'Notifications enabled',
          value: _notificationsOn,
          onChanged: (val) => setState(() => _notificationsOn = val),
        ),
        const SizedBox(height: 12),
        SketchyText(
          'Use toggles for quick binary actions—no material switch required.',
          style: _mutedStyle(context),
        ),
      ],
    ),
  );

  Widget _buildToggleOption({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Row(
    children: [
      SketchyToggle(value: value, onChanged: onChanged),
      const SizedBox(width: 12),
      Expanded(child: SketchyText(label, style: _bodyStyle(context))),
    ],
  );

  Widget _buildComboSection() => _sectionCard(
    title: 'Sketchy combo',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Cadence', style: _fieldLabelStyle(context)),
        const SizedBox(height: 4),
        SketchyCombo<String>(
          value: _selectedCadence,
          items: _cadenceOptions
              .map(
                (c) => SketchyComboItem<String>(
                  value: c,
                  child: SketchyText(c, style: _bodyStyle(context)),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedCadence = val);
          },
        ),
        const SizedBox(height: 8),
        SketchyText(
          'Currently sending a $_selectedCadence digest.',
          style: _mutedStyle(context),
        ),
      ],
    ),
  );

  Widget _buildDialogSection() {
    final theme = SketchyTheme.of(context);
    return _sectionCard(
      title: 'Sketchy dialog',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Dialogs keep the same rough frame and '
            'Comic Shanns tone.',
            style: _mutedStyle(context),
          ),
          const SizedBox(height: 12),
          SketchyButton(
            child: SketchyText(
              'Open dialog',
              style: _buttonLabelStyle(context),
            ),
            onPressed: () {
              unawaited(
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Dismiss dialog',
                  barrierColor: theme.colors.ink.withValues(alpha: 0.55),
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                            child: child,
                          ),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SketchyDialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SketchyText(
                              'This is a sketchy dialog.',
                              style: _titleStyle(context),
                            ),
                            const SizedBox(height: 24),
                            SketchyText(
                              'It has a title and some content.',
                              style: _bodyStyle(context),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SketchyButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: SketchyText(
                                    'Close',
                                    style: _buttonLabelStyle(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    double? height,
  }) => SketchyCard(
    height: height,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(title, style: _titleStyle(context)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );

  TextStyle _titleStyle(BuildContext context) => SketchyTheme.of(
    context,
  ).typography.title.copyWith(fontWeight: FontWeight.bold);

  TextStyle _bodyStyle(BuildContext context) =>
      SketchyTheme.of(context).typography.body;

  TextStyle _mutedStyle(BuildContext context) => SketchyTheme.of(
    context,
  ).typography.caption.copyWith(color: const Color(0xFF9E9E9E));

  TextStyle _fieldLabelStyle(BuildContext context) => SketchyTheme.of(
    context,
  ).typography.label.copyWith(fontWeight: FontWeight.bold);

  TextStyle _buttonLabelStyle(BuildContext context, {Color? color}) =>
      SketchyTheme.of(
        context,
      ).typography.label.copyWith(fontWeight: FontWeight.bold, color: color);

  String _textCaseLabel(TextCase casing) {
    switch (casing) {
      case TextCase.none:
        return 'None';
      case TextCase.allCaps:
        return 'All Caps';
      case TextCase.titleCase:
        return 'Title Case';
      case TextCase.allLower:
        return 'All Lower';
    }
  }
}
