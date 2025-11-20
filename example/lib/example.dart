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
  required SketchyThemes theme,
  required double roughness,
  required String fontFamily,
  required TextCase textCase,
  required SketchyThemeMode mode,
}) {
  // Determine brightness based on the app mode setting
  // Note: In a real app, 'system' would check MediaQuery, but here we simulate.
  final brightness = mode == SketchyThemeMode.dark
      ? Brightness.dark
      : Brightness.light;

  final data = SketchyThemeData.fromTheme(
    theme,
    brightness: brightness,
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
    required this.theme,
  });

  final String id;
  final String label;
  final SketchyThemes theme;
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
      theme: SketchyThemes.monochrome,
    ),
    PaletteOption(id: 'red', label: 'Red', theme: SketchyThemes.red),
    PaletteOption(id: 'orange', label: 'Orange', theme: SketchyThemes.orange),
    PaletteOption(id: 'yellow', label: 'Yellow', theme: SketchyThemes.yellow),
    PaletteOption(id: 'green', label: 'Green', theme: SketchyThemes.green),
    PaletteOption(id: 'cyan', label: 'Cyan', theme: SketchyThemes.cyan),
    PaletteOption(id: 'blue', label: 'Blue', theme: SketchyThemes.blue),
    PaletteOption(id: 'indigo', label: 'Indigo', theme: SketchyThemes.indigo),
    PaletteOption(id: 'violet', label: 'Violet', theme: SketchyThemes.violet),
    PaletteOption(
      id: 'magenta',
      label: 'Magenta',
      theme: SketchyThemes.magenta,
    ),
  ];

  PaletteOption get _activePalette =>
      _palettes.firstWhere((option) => option.id == _activePaletteId);

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Sketchy Design System',
    theme: _resolveSketchyTheme(
      theme: _activePalette.theme,
      roughness: _roughness,
      fontFamily: _fontFamily,
      textCase: _textCase,
      mode: SketchyThemeMode.light, // Base theme is light
    ),
    // We pass a specific dark theme derived from the same palette but swapped
    darkTheme: _resolveSketchyTheme(
      theme: _activePalette.theme,
      roughness: _roughness,
      fontFamily: _fontFamily,
      textCase: _textCase,
      mode: SketchyThemeMode.dark,
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
  bool _pinnedChip = true;
  bool _snoozedChip = false;
  bool _archiveChip = true;
  bool _iconOnlyChip = false;
  bool _followUpsEnabled = true;
  int _selectedConversationTab = 0;
  static const List<String> _conversationTabs = ['Inbox', 'Updates', 'Archive'];
  static const List<String> _conversationSenders = [
    'Archie',
    'Product Ops',
    'System Bot',
  ];
  static const List<String> _conversationMessages = [
    'Inbox is stacked, so I drafted two quick replies for you.',
    'Palette tweaks landed in QA. Want me to grab reactions later?',
    'Archive is empty—want me to auto-file anything over a week old?',
  ];

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
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final palette = widget.palette;
      return SketchyScaffold(
        appBar: _buildHeroAppBar(theme),
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
    },
  );

  SketchyAppBar _buildHeroAppBar(SketchyThemeData theme) => SketchyAppBar(
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

  Widget _buildThemeRow(PaletteOption active) => SketchyTheme.consumer(
    builder: (context, theme) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyText('Theme colors', style: _titleStyle(theme)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.palettes.map((option) {
            final isActive = option.id == active.id;
            final previewTheme = _resolveSketchyTheme(
              theme: option.theme,
              roughness: 0.5,
              fontFamily: widget.fontFamily,
              textCase: TextCase.none,
              mode: SketchyThemeMode.light,
            );

            return GestureDetector(
              onTap: () => widget.onThemeChanged(option.id),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorChip(previewTheme.primaryColor, isActive),
                  const SizedBox(height: 4),
                  _colorChip(
                    previewTheme.secondaryColor,
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
    ),
  );

  Widget _colorChip(
    Color color,
    bool isActive, {
    bool stroke = false,
    double size = 26,
  }) => SketchyTheme.consumer(
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

  Widget _buildModeToggleRow() => SketchyTheme.consumer(
    builder: (context, theme) {
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
                theme,
                color: isActive
                    ? theme.primaryColor
                    : theme.inkColor.withValues(alpha: 0.5),
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
                    child: SketchyText(entry.key, style: _bodyStyle(theme)),
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
                      style: _bodyStyle(theme),
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
    },
  );

  Widget _buildShowcaseBoard() {
    final cards = <Widget>[
      _buildButtonsSection(),
      _buildChipSection(),
      _buildIconTileSection(),
      _buildConversationSection(),
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

  Widget _buildButtonsSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy buttons',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyButton(
            child: SketchyText(
              'Sketchy Button',
              style: _buttonLabelStyle(theme),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SketchyButton(
                child: SketchyText(
                  'Submit',
                  style: _buttonLabelStyle(theme, color: theme.primaryColor),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              SketchyButton(
                child: SketchyText(
                  'Cancel',
                  style: _buttonLabelStyle(
                    theme,
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
              style: _buttonLabelStyle(theme),
            ),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );

  Widget _buildChipSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy chips',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _chipGallery(theme, 'Chip', const [
                  SketchyChip(
                    label: 'New drop',
                    compact: true,
                    tone: SketchyChipTone.neutral,
                  ),
                  SketchyChip(
                    label: 'Shipped!',
                    compact: true,
                    filled: true,
                    tone: SketchyChipTone.accent,
                    fillStyle: SketchyFill.solid,
                  ),
                  SketchyChip(
                    label: '',
                    compact: true,
                    filled: true,
                    tone: SketchyChipTone.accent,
                    icon: SketchyIcons.check,
                    iconOnly: true,
                    fillStyle: SketchyFill.solid,
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _chipGallery(theme, 'Choice', [
                  SketchyChip.choice(
                    label: 'Pinned',
                    selected: _pinnedChip,
                    fillStyle: SketchyFill.hachure,
                    onSelected: () =>
                        setState(() => _pinnedChip = !_pinnedChip),
                  ),
                  SketchyChip.choice(
                    label: 'Snooze',
                    selected: _snoozedChip,
                    fillStyle: SketchyFill.hachure,
                    onSelected: () =>
                        setState(() => _snoozedChip = !_snoozedChip),
                  ),
                  SketchyChip.choice(
                    label: 'Archive',
                    selected: _archiveChip,
                    icon: SketchyIcons.rectangle,
                    fillStyle: SketchyFill.solid,
                    onSelected: () =>
                        setState(() => _archiveChip = !_archiveChip),
                  ),
                  SketchyChip.choice(
                    label: '',
                    selected: _iconOnlyChip,
                    icon: SketchyIcons.send,
                    iconOnly: true,
                    fillStyle: SketchyFill.solid,
                    onSelected: () =>
                        setState(() => _iconOnlyChip = !_iconOnlyChip),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _chipGallery(theme, 'Badge', const [
                  SketchyChip.badge(
                    label: 'Beta',
                    tone: SketchyChipTone.accent,
                    fillStyle: SketchyFill.hachure,
                  ),
                  SketchyChip.badge(
                    label: 'Muted',
                    tone: SketchyChipTone.neutral,
                  ),
                  SketchyChip.badge(
                    label: 'Beta tag',
                    tone: SketchyChipTone.accent,
                    icon: SketchyIcons.pen,
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _chipGallery(theme, 'Suggestion', const [
                  SketchyChip(
                    label: '#sketchythings',
                    tone: SketchyChipTone.neutral,
                  ),
                  SketchyChip(
                    label: 'Palette',
                    tone: SketchyChipTone.accent,
                    fillStyle: SketchyFill.hachure,
                  ),
                  SketchyChip(
                    label: '',
                    tone: SketchyChipTone.accent,
                    icon: SketchyIcons.plus,
                    iconOnly: true,
                    fillStyle: SketchyFill.solid,
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _chipGallery(
    SketchyThemeData theme,
    String title,
    List<Widget> chips,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SketchyText(title, style: _fieldLabelStyle(theme)),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 8, children: chips),
    ],
  );

  Widget _buildIconTileSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Icons & tiles',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SketchyIconButton(icon: SketchyIcons.plus, onPressed: () {}),
              const SizedBox(width: 12),
              SketchyIconButton(icon: SketchyIcons.pen, onPressed: () {}),
              const SizedBox(width: 12),
              SketchyIconButton(icon: SketchyIcons.send, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 16),
          SketchyListTile(
            leading: const SketchyIcon(icon: SketchyIcons.pen),
            title: SketchyText('Brand refresh', style: _bodyStyle(theme)),
            subtitle: SketchyText(
              'Rally design + docs for review',
              style: _mutedStyle(theme),
            ),
            trailing: SketchyIconButton(
              icon: SketchyIcons.check,
              onPressed: () {},
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          SketchyListTile(
            leading: const SketchyIcon(icon: SketchyIcons.copy),
            title: SketchyText('Follow-up nudges', style: _bodyStyle(theme)),
            subtitle: SketchyText(
              'Mute autopings after 10pm',
              style: _mutedStyle(theme),
            ),
            trailing: SketchyToggle(
              value: _followUpsEnabled,
              onChanged: (value) => setState(() {
                _followUpsEnabled = value;
              }),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildConversationSection() => SketchyTheme.consumer(
    builder: (context, theme) {
      final tabIndex = _selectedConversationTab;
      final sender = _conversationSenders[tabIndex];
      final message = _conversationMessages[tabIndex];
      return _sectionCard(
        title: 'Conversation cues',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SketchyTabs(
              tabs: _conversationTabs,
              selectedIndex: tabIndex,
              detachSelected: true,
              detachGap: theme.strokeWidth,
              backgroundColor: theme.paperColor,
              eraseSelectedBorder: true,
              onChanged: (index) {
                setState(() => _selectedConversationTab = index);
              },
            ),
            Transform.translate(
              offset: Offset(0, -theme.strokeWidth),
              child: SketchySurface(
                padding: const EdgeInsets.all(16),
                strokeColor: theme.inkColor,
                fillColor: theme.paperColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SketchyText(
                      sender,
                      style: theme.typography.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SketchyText(message, style: _bodyStyle(theme)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12 - theme.strokeWidth),
            Row(
              children: [
                const SketchyTypingIndicator(),
                const SizedBox(width: 8),
                Expanded(
                  child: SketchyText(
                    'Archie is drafting a reply…',
                    style: _mutedStyle(theme),
                  ),
                ),
                SketchyButton(
                  onPressed: () {
                    SketchyToast.show(
                      context,
                      message: 'Saved ${_conversationTabs[tabIndex]} note',
                    );
                  },
                  child: SketchyText(
                    'Show toast',
                    style: _buttonLabelStyle(theme),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  Widget _buildDividerSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy divider',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
            'eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
            style: _bodyStyle(theme),
          ),
          const SizedBox(height: 12),
          const SketchyDivider(),
          const SizedBox(height: 12),
          SketchyText(
            'Duis aute irure dolor in reprehenderit in voluptate velit esse '
            'cillum dolore eu fugiat nulla pariatur.',
            style: _bodyStyle(theme),
          ),
        ],
      ),
    ),
  );

  Widget _buildInputsSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy input',
      height: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText('Name', style: _fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          SketchyTextInput(
            controller: _nameController,
            hintText: 'Hello sketchy input',
            style: _bodyStyle(theme),
            hintStyle: _mutedStyle(theme),
          ),
          const SizedBox(height: 12),
          SketchyText('User Email', style: _fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          SketchyTextInput(
            controller: _emailController,
            hintText: 'Please enter user email',
            style: _bodyStyle(theme),
            hintStyle: _mutedStyle(theme),
          ),
          const SizedBox(height: 12),
          SketchyText('Your age', style: _fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          SketchyTextInput(
            controller: _ageController,
            hintText: 'Your age please!',
            style: _bodyStyle(theme),
            hintStyle: _mutedStyle(theme),
          ),
        ],
      ),
    ),
  );

  Widget _buildRadioSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy radio',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyOptionTile<String>.radio(
            value: 'Lafayette',
            groupValue: _selectedRadio,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedRadio = value);
            },
            label: SketchyText('Lafayette', style: _bodyStyle(theme)),
          ),
          const SizedBox(height: 8),
          SketchyOptionTile<String>.radio(
            value: 'Thomas Jefferson',
            groupValue: _selectedRadio,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedRadio = value);
            },
            label: SketchyText('Thomas Jefferson', style: _bodyStyle(theme)),
          ),
        ],
      ),
    ),
  );

  Widget _buildSliderSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy slider',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Value: ${(100 * _sliderValue).round()}',
            style: _fieldLabelStyle(
              theme,
            ).copyWith(color: theme.secondaryColor),
          ),
          const SizedBox(height: 8),
          SketchySlider(
            value: _sliderValue,
            onChanged: (newValue) =>
                setState(() => _sliderValue = newValue.clamp(0.0, 1.0)),
          ),
        ],
      ),
    ),
  );

  Widget _buildProgressSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
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
                  style: _buttonLabelStyle(theme, color: theme.primaryColor),
                ),
              ),
              const SizedBox(width: 8),
              SketchyButton(
                onPressed: _stopProgress,
                child: SketchyText(
                  'Stop',
                  style: _buttonLabelStyle(theme, color: theme.errorColor),
                ),
              ),
              const SizedBox(width: 8),
              SketchyButton(
                onPressed: _resetProgress,
                child: SketchyText('Reset', style: _buttonLabelStyle(theme)),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildCalendarSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy calendar',
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            '${_selectedDate.year} - '
            '${_selectedDate.month.toString().padLeft(2, '0')} - '
            '${_selectedDate.day.toString().padLeft(2, '0')}',
            style: _fieldLabelStyle(theme),
          ),
          const SizedBox(height: 8),
          SizedBox(
            child: SketchyCalendar(
              selected: _selectedDate,
              onSelected: (date) => setState(() => _selectedDate = date),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildCheckboxSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy checkbox',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyOptionTile.checkbox(
            value: _newsletterOptIn,
            onChanged: (checked) =>
                setState(() => _newsletterOptIn = checked ?? false),
            label: SketchyText(
              'Send me sketchy release notes',
              style: _bodyStyle(theme),
            ),
            helper: SketchyText(
              'Early builds + easter eggs',
              style: _mutedStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          SketchyOptionTile.checkbox(
            value: _mascotOptIn,
            onChanged: (checked) =>
                setState(() => _mascotOptIn = checked ?? false),
            label: SketchyText('Mascot mode', style: _bodyStyle(theme)),
            helper: SketchyText(
              'More sketchy faces',
              style: _mutedStyle(theme),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildToggleSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy toggle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleOption(
            theme: theme,
            label: 'Notifications enabled',
            value: _notificationsOn,
            onChanged: (val) => setState(() => _notificationsOn = val),
          ),
          const SizedBox(height: 12),
          SketchyText(
            'Use toggles for quick binary actions—no material switch required.',
            style: _mutedStyle(theme),
          ),
        ],
      ),
    ),
  );

  Widget _buildToggleOption({
    required SketchyThemeData theme,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Row(
    children: [
      SketchyToggle(value: value, onChanged: onChanged),
      const SizedBox(width: 12),
      Expanded(child: SketchyText(label, style: _bodyStyle(theme))),
    ],
  );

  Widget _buildComboSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy combo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText('Cadence', style: _fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          SketchyCombo<String>(
            value: _selectedCadence,
            items: _cadenceOptions
                .map(
                  (c) => SketchyComboItem<String>(
                    value: c,
                    child: SketchyText(c, style: _bodyStyle(theme)),
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
            style: _mutedStyle(theme),
          ),
        ],
      ),
    ),
  );

  // Example using the consumer pattern (recommended)
  Widget _buildDialogSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy dialog',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SketchyText(
            'Dialogs keep the same rough frame and '
            'Comic Shanns tone.',
            style: _mutedStyle(theme),
          ),
          const SizedBox(height: 12),
          SketchyButton(
            child: SketchyText('Open dialog', style: _buttonLabelStyle(theme)),
            onPressed: () {
              unawaited(
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Dismiss dialog',
                  barrierColor: theme.inkColor.withValues(alpha: 0.55),
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
                            SketchyTheme.consumer(
                              builder: (ctx, dialogTheme) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SketchyText(
                                    'This is a sketchy dialog.',
                                    style: _titleStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  SketchyText(
                                    'It has a title and some content.',
                                    style: _bodyStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SketchyButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: SketchyText(
                                          'Close',
                                          style: _buttonLabelStyle(dialogTheme),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
    ),
  );

  Widget _sectionCard({
    required String title,
    required Widget child,
    double? height,
  }) => SketchyTheme.consumer(
    builder: (context, theme) => SketchyCard(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SketchyText(title, style: _titleStyle(theme)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    ),
  );

  TextStyle _titleStyle(SketchyThemeData theme) =>
      theme.typography.title.copyWith(fontWeight: FontWeight.bold);

  TextStyle _bodyStyle(SketchyThemeData theme) => theme.typography.body;

  TextStyle _mutedStyle(SketchyThemeData theme) =>
      theme.typography.caption.copyWith(color: const Color(0xFF9E9E9E));

  TextStyle _fieldLabelStyle(SketchyThemeData theme) =>
      theme.typography.label.copyWith(fontWeight: FontWeight.bold);

  TextStyle _buttonLabelStyle(SketchyThemeData theme, {Color? color}) => theme
      .typography
      .label
      .copyWith(fontWeight: FontWeight.bold, color: color);

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
