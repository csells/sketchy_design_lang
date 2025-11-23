import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ComboSection extends StatefulWidget {
  const ComboSection({super.key});

  @override
  State<ComboSection> createState() => _ComboSectionState();
}

class _ComboSectionState extends State<ComboSection> {
  String _selectedCadence = 'Weekly';
  static const List<String> _cadenceOptions = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy combo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cadence', style: fieldLabelStyle(theme)),
          const SizedBox(height: 4),
          SketchyDropdownButton<String>(
            value: _selectedCadence,
            items: [
              for (final c in _cadenceOptions)
                SketchyDropdownMenuItem<String>(
                  value: c,
                  child: Text(c, style: bodyStyle(theme)),
                ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedCadence = val);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Currently sending a $_selectedCadence digest.',
            style: mutedStyle(theme),
          ),
        ],
      ),
    ),
  );
}
