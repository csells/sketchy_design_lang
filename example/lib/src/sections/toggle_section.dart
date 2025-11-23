import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ToggleSection extends StatefulWidget {
  const ToggleSection({super.key});

  @override
  State<ToggleSection> createState() => _ToggleSectionState();
}

class _ToggleSectionState extends State<ToggleSection> {
  bool _notificationsOn = true;

  Widget _buildToggleOption({
    required SketchyThemeData theme,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Row(
    children: [
      Switch(value: value, onChanged: onChanged),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: bodyStyle(theme))),
    ],
  );

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
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
            style: mutedStyle(theme),
          ),
        ],
      ),
    ),
  );
}
