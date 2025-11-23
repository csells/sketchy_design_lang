import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class CheckboxSection extends StatefulWidget {
  const CheckboxSection({super.key});

  @override
  State<CheckboxSection> createState() => _CheckboxSectionState();
}

class _CheckboxSectionState extends State<CheckboxSection> {
  bool _newsletterOptIn = true;
  bool _mascotOptIn = false;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
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
              style: bodyStyle(theme),
            ),
            subtitle: Text(
              'Early builds + easter eggs',
              style: mutedStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _mascotOptIn,
            onChanged: (checked) =>
                setState(() => _mascotOptIn = checked ?? false),
            title: Text('Mascot mode', style: bodyStyle(theme)),
            subtitle: Text('More sketchy faces', style: mutedStyle(theme)),
          ),
        ],
      ),
    ),
  );
}
