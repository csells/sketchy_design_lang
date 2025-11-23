import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy buttons',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
            child: Text('Sketchy Button', style: buttonLabelStyle(theme)),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                child: Text(
                  'Submit',
                  style: buttonLabelStyle(theme, color: theme.primaryColor),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                child: Text(
                  'Cancel',
                  style: buttonLabelStyle(
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
              style: buttonLabelStyle(theme),
            ),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}
