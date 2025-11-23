import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class RadioSection extends StatefulWidget {
  const RadioSection({super.key});

  @override
  State<RadioSection> createState() => _RadioSectionState();
}

class _RadioSectionState extends State<RadioSection> {
  String _selectedRadio = 'Lafayette';

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
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
            title: Text('Lafayette', style: bodyStyle(theme)),
          ),
          const SizedBox(height: 8),
          RadioListTile<String>(
            value: 'Thomas Jefferson',
            groupValue: _selectedRadio,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedRadio = value);
            },
            title: Text('Thomas Jefferson', style: bodyStyle(theme)),
          ),
        ],
      ),
    ),
  );
}
