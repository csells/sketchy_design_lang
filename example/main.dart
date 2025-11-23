import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart' hide Text;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

Map<String, String> get _fontOptions => <String, String>{
  'Comic Shanns': 'ComicShanns',
  'Excalifont': 'Excalifont',
  'xkcd': 'XKCD',
  'Gloria Hallelujah':
      GoogleFonts.gloriaHallelujah().fontFamily ?? 'ComicShanns',
};

SketchyThemeData _resolveSketchyTheme({
  required SketchyThemes theme,
  required double roughness,
  required String fontFamily,
  required TextCase textCase,
  required SketchyThemeMode mode,
}) {
  // Determine brightness based on the app mode setting Note: In a real app,
  // 'system' would check MediaQuery, but here we simulate.
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
  // State for the "sketchy" components
  static const double _cardWidth = 520;
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
  late final TabController _conversationTabController;

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
    _conversationTabController = TabController(
      length: _conversationTabs.length,
      initialIndex: _selectedConversationTab,
      vsync: this,
    );
    _conversationTabController.addListener(() {
      // if (_conversationTabController.indexIsChanging) return;
      setState(
        () => _selectedConversationTab = _conversationTabController.index,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _progressController.dispose();
    _conversationTabController.dispose();
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
      return Scaffold(
        appBar: _buildHeroAppBar(theme),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigSection(palette),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildShowcaseBoard(),
              ),
            ),
          ],
        ),
      );
    },
  );

  AppBar _buildHeroAppBar(SketchyThemeData theme) => AppBar(
    margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
    padding: const EdgeInsets.all(16),
    leading: Tooltip(
      message: 'meh.',
      preferBelow: true,
      child: SketchyFrame(
        child: SizedBox(
          width: 96,
          height: 96,
          child: Center(
            child: Image.asset(
              'assets/images/sketchy_mascot.png',
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sketchy',
          style: theme.typography.headline.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text('''
A hand-drawn, xkcd-inspired design language for Flutter on mobile, desktop, and
web powered by the wired_elements code, the flutter_rough package and the
Comic Shanns font.
''', style: theme.typography.title.copyWith(fontSize: 14)),
      ],
    ),
  );

  Widget _buildConfigSection(PaletteOption palette) => SketchyTheme.consumer(
    builder: (context, theme) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          _buildThemeColorsControl(palette),
          ..._buildSettingsControls(theme),
        ],
      ),
    ),
  );

  Widget _buildControlGroup(
    SketchyThemeData theme, {
    required String label,
    required Widget child,
    double? width,
  }) {
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

  Widget _buildThemeColorsControl(PaletteOption active) =>
      SketchyTheme.consumer(
        builder: (context, theme) => _buildControlGroup(
          theme,
          label: 'Theme Colors',
          child: Wrap(
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
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
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

  List<Widget> _buildSettingsControls(SketchyThemeData theme) {
    final activeMode = widget.themeMode;
    final labelStyle = theme.typography.label.copyWith(
      fontWeight: FontWeight.bold,
    );

    Widget modeButton(String label, SketchyThemeMode mode) {
      final isActive = activeMode == mode;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: OutlinedButton(
          onPressed: isActive ? null : () => widget.onThemeModeChanged(mode),
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
      _buildControlGroup(
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
      _buildControlGroup(
        theme,
        label: 'Roughness',
        width: 240,
        child: Slider(
          value: widget.roughness,
          onChanged: (value) =>
              widget.onRoughnessChanged(value.clamp(0.0, 1.0)),
        ),
      ),
      _buildControlGroup(
        theme,
        label: 'Font',
        width: 240,
        child: DropdownButton<String>(
          value: widget.fontFamily,
          items: _fontOptions.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key, style: theme.typography.body),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) widget.onFontChanged(value);
          },
        ),
      ),
      _buildControlGroup(
        theme,
        label: 'Title Casing',
        width: 240,
        child: DropdownButton<TextCase>(
          value: widget.textCase,
          items: TextCase.values
              .map(
                (casing) => DropdownMenuItem<TextCase>(
                  value: casing,
                  child: Text(
                    _textCaseLabel(casing),
                    style: theme.typography.body,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) widget.onTitleCasingChanged(value);
          },
        ),
      ),
    ];
  }

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
          OutlinedButton(
            child: Text('Sketchy Button', style: _buttonLabelStyle(theme)),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                child: Text(
                  'Submit',
                  style: _buttonLabelStyle(theme, color: theme.primaryColor),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                child: Text(
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
          OutlinedButton(
            child: Text(
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
                child: _chipGallery(theme, 'Chip', [
                  const Chip(
                    label: Text('New drop'),
                    compact: true,
                    tone: SketchyChipTone.neutral,
                  ),
                  Chip(
                    label: const Text('Shipped!'),
                    compact: true,
                    // filled: true, // Material Chip doesn't support filled
                    // directly here in this context easily, but my Chip impl
                    // does I'll assume my Chip class from chip.dart is used
                    // Wait, Chip in chip.dart accepts filled? No, Chip in
                    // chip.dart sets filled: false. I need to expose filled or
                    // use backgroundColor. I'll use backgroundColor which maps
                    // to fill in _SketchyChipImpl
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.35),
                    tone: SketchyChipTone.accent,
                  ),
                  Chip(
                    label: const Text(''),
                    compact: true,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.35),
                    tone: SketchyChipTone.accent,
                    avatar: const FaIcon(FontAwesomeIcons.check),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _chipGallery(theme, 'Choice', [
                  ChoiceChip(
                    label: const Text('Pinned'),
                    selected: _pinnedChip,
                    onSelected: (val) => setState(() => _pinnedChip = val),
                  ),
                  ChoiceChip(
                    label: const Text('Snooze'),
                    selected: _snoozedChip,
                    onSelected: (val) => setState(() => _snoozedChip = val),
                  ),
                  ChoiceChip(
                    label: const Text('Archive'),
                    selected: _archiveChip,
                    avatar: const FaIcon(FontAwesomeIcons.square),
                    onSelected: (val) => setState(() => _archiveChip = val),
                  ),
                  ChoiceChip(
                    label: const Text(''),
                    selected: _iconOnlyChip,
                    avatar: const FaIcon(FontAwesomeIcons.paperPlane),
                    onSelected: (val) => setState(() => _iconOnlyChip = val),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _chipGallery(theme, 'Badge', [
                  Chip(
                    label: const Text('Beta'),
                    compact: true,
                    tone: SketchyChipTone.accent,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                  ),
                  Chip(
                    label: const Text('Muted'),
                    compact: true,
                    tone: SketchyChipTone.neutral,
                    backgroundColor: theme.paperColor,
                  ),
                  const Chip(
                    label: Text('Beta tag'),
                    compact: true,
                    tone: SketchyChipTone.accent,
                    avatar: FaIcon(FontAwesomeIcons.pen),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _chipGallery(theme, 'Suggestion', [
                  ActionChip(
                    label: const Text('#sketchythings'),
                    onPressed: () {},
                    tone: SketchyChipTone.neutral,
                  ),
                  ActionChip(
                    label: const Text('Palette'),
                    onPressed: () {},
                    tone: SketchyChipTone.accent,
                  ),
                  ActionChip(
                    label: const Text(''),
                    onPressed: () {},
                    tone: SketchyChipTone.accent,
                    avatar: const FaIcon(FontAwesomeIcons.plus),
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
      Text(title, style: _fieldLabelStyle(theme)),
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
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.plus),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.pen),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.pen),
            title: Text('Brand refresh', style: _bodyStyle(theme)),
            subtitle: Text(
              'Rally design + docs for review',
              style: _mutedStyle(theme),
            ),
            trailing: IconButton(
              icon: const FaIcon(FontAwesomeIcons.check),
              onPressed: () {},
              iconSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.copy),
            title: Text('Follow-up nudges', style: _bodyStyle(theme)),
            subtitle: Text(
              'Mute autopings after 10pm',
              style: _mutedStyle(theme),
            ),
            trailing: Switch(
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
            TabBar(
              controller: _conversationTabController,
              tabs: _conversationTabs.map(Text.new).toList(),
              detachSelected: true,
              detachGap: theme.strokeWidth,
              backgroundColor: theme.paperColor,
              eraseSelectedBorder: true,
              onTap: (index) {
                // The controller listener handles the state update
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
                    Text(
                      sender,
                      style: theme.typography.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(message, style: _bodyStyle(theme)),
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
                  child: Text(
                    'Archie is drafting a reply…',
                    style: _mutedStyle(theme),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    SnackBar.show(
                      context,
                      message: 'Saved ${_conversationTabs[tabIndex]} note',
                    );
                  },
                  child: Text('Show toast', style: _buttonLabelStyle(theme)),
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
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
            'eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
            style: _bodyStyle(theme),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
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
          // TextField with decoration
          TextField(
            controller: _nameController,
            style: _bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Hello sketchy input',
              hintStyle: _mutedStyle(theme),
              labelStyle: _fieldLabelStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            style: _bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'User Email',
              hintText: 'Please enter user email',
              hintStyle: _mutedStyle(theme),
              labelStyle: _fieldLabelStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ageController,
            style: _bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'Your age',
              hintText: 'Your age please!',
              hintStyle: _mutedStyle(theme),
              labelStyle: _fieldLabelStyle(theme),
            ),
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
          RadioListTile<String>(
            value: 'Lafayette',
            groupValue: _selectedRadio,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedRadio = value);
            },
            title: Text('Lafayette', style: _bodyStyle(theme)),
          ),
          const SizedBox(height: 8),
          RadioListTile<String>(
            value: 'Thomas Jefferson',
            groupValue: _selectedRadio,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedRadio = value);
            },
            title: Text('Thomas Jefferson', style: _bodyStyle(theme)),
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
          Text(
            'Value: ${(100 * _sliderValue).round()}',
            style: _fieldLabelStyle(
              theme,
            ).copyWith(color: theme.secondaryColor),
          ),
          const SizedBox(height: 8),
          Slider(
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
          LinearProgressIndicator(controller: _progressController, value: 0),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _startProgress,
                child: Text(
                  'Start',
                  style: _buttonLabelStyle(theme, color: theme.primaryColor),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _stopProgress,
                child: Text(
                  'Stop',
                  style: _buttonLabelStyle(theme, color: theme.errorColor),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _resetProgress,
                child: Text('Reset', style: _buttonLabelStyle(theme)),
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
          Text(
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
          CheckboxListTile(
            value: _newsletterOptIn,
            onChanged: (checked) =>
                setState(() => _newsletterOptIn = checked ?? false),
            title: Text(
              'Send me sketchy release notes',
              style: _bodyStyle(theme),
            ),
            subtitle: Text(
              'Early builds + easter eggs',
              style: _mutedStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _mascotOptIn,
            onChanged: (checked) =>
                setState(() => _mascotOptIn = checked ?? false),
            title: Text('Mascot mode', style: _bodyStyle(theme)),
            subtitle: Text('More sketchy faces', style: _mutedStyle(theme)),
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
          Text(
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
      Switch(value: value, onChanged: onChanged),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: _bodyStyle(theme))),
    ],
  );

  Widget _buildComboSection() => SketchyTheme.consumer(
    builder: (context, theme) => _sectionCard(
      title: 'Sketchy combo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cadence', style: _fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: _selectedCadence,
            items: _cadenceOptions
                .map(
                  (c) => DropdownMenuItem<String>(
                    value: c,
                    child: Text(c, style: _bodyStyle(theme)),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCadence = val);
            },
          ),
          const SizedBox(height: 8),
          Text(
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
          Text(
            'Dialogs keep the same rough frame and '
            'Comic Shanns tone.',
            style: _mutedStyle(theme),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            child: Text('Open dialog', style: _buttonLabelStyle(theme)),
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
                      Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SketchyTheme.consumer(
                              builder: (ctx, dialogTheme) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This is a sketchy dialog.',
                                    style: _titleStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'It has a title and some content.',
                                    style: _bodyStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
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
    builder: (context, theme) => Card(
      // height: height, // Card doesn't support height directly in Material,
      // but SketchyCard did? My Card implementation passes height to
      // SketchyFrame? Wait, my Card implementation does NOT accept height.
      // Standard Card doesn't. I should wrap child in SizedBox if height is
      // needed.
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _titleStyle(theme)),
              const SizedBox(height: 16),
              child,
            ],
          ),
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
