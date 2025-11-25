import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../sections/buttons_section.dart';
import '../sections/calendar_section.dart';
import '../sections/checkbox_section.dart';
import '../sections/chip_section.dart';
import '../sections/combo_section.dart';
import '../sections/conversation_section.dart';
import '../sections/dialog_section.dart';
import '../sections/divider_section.dart';
import '../sections/icon_tile_section.dart';
import '../sections/inputs_section.dart';
import '../sections/progress_section.dart';
import '../sections/radio_section.dart';
import '../sections/slider_section.dart';
import '../sections/toggle_section.dart';
import 'config_section.dart';
import 'hero_app_bar.dart';

class SketchyDesignSystemPage extends StatelessWidget {
  const SketchyDesignSystemPage({
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

  static const double _cardWidth = 520;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SketchyScaffold(
      appBar: const HeroAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConfigSection(
              activeTheme: activeTheme,
              themeMode: themeMode,
              onThemeModeChanged: onThemeModeChanged,
              onThemeChanged: onThemeChanged,
              roughness: roughness,
              onRoughnessChanged: onRoughnessChanged,
              fontFamily: fontFamily,
              onFontChanged: onFontChanged,
              textCase: textCase,
              onTitleCasingChanged: onTitleCasingChanged,
            ),
            const SketchyDivider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width;
                  final cardWidth = math.min(_cardWidth, availableWidth);

                  final cards = <Widget>[
                    const ButtonsSection(),
                    const ChipSection(),
                    const IconTileSection(),
                    const ConversationSection(),
                    const DividerSection(),
                    const InputsSection(),
                    const RadioSection(),
                    const SliderSection(),
                    const ProgressSection(),
                    const CheckboxSection(),
                    const ToggleSection(),
                    const ComboSection(),
                    const DialogSection(),
                    const CalendarSection(),
                  ];

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: cards
                        .map((card) => SizedBox(width: cardWidth, child: card))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
