import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ChipSection extends StatefulWidget {
  const ChipSection({super.key});

  @override
  State<ChipSection> createState() => _ChipSectionState();
}

class _ChipSectionState extends State<ChipSection> {
  bool _pinnedChip = true;
  bool _snoozedChip = false;
  bool _archiveChip = true;
  bool _iconOnlyChip = false;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy chips',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ChipGallery(
                  theme: theme,
                  title: 'Chip',
                  chips: [
                    const Chip(
                      label: Text('New drop'),
                      compact: true,
                      tone: SketchyChipTone.neutral,
                    ),
                    Chip(
                      label: const Text('Shipped!'),
                      compact: true,
                      backgroundColor: theme.primaryColor.withValues(
                        alpha: 0.35,
                      ),
                      tone: SketchyChipTone.accent,
                    ),
                    Chip(
                      label: const Text(''),
                      compact: true,
                      backgroundColor: theme.primaryColor.withValues(
                        alpha: 0.35,
                      ),
                      tone: SketchyChipTone.accent,
                      avatar: const FaIcon(FontAwesomeIcons.check),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ChipGallery(
                  theme: theme,
                  title: 'Choice',
                  chips: [
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ChipGallery(
                  theme: theme,
                  title: 'Badge',
                  chips: [
                    Chip(
                      label: const Text('Beta'),
                      compact: true,
                      tone: SketchyChipTone.accent,
                      backgroundColor: theme.primaryColor.withValues(
                        alpha: 0.2,
                      ),
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
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ChipGallery(
                  theme: theme,
                  title: 'Suggestion',
                  chips: [
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ChipGallery extends StatelessWidget {
  const _ChipGallery({
    required this.theme,
    required this.title,
    required this.chips,
  });

  final SketchyThemeData theme;
  final String title;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: fieldLabelStyle(theme)),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 8, children: chips),
    ],
  );
}
