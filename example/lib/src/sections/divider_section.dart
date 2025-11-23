import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class DividerSection extends StatelessWidget {
  const DividerSection({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy divider',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
            'eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
            style: bodyStyle(theme),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Duis aute irure dolor in reprehenderit in voluptate velit esse '
            'cillum dolore eu fugiat nulla pariatur.',
            style: bodyStyle(theme),
          ),
        ],
      ),
    ),
  );
}
