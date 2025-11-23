import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  double _sliderValue = 0.2;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy slider',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Value: ${(100 * _sliderValue).round()}',
            style: fieldLabelStyle(theme).copyWith(color: theme.secondaryColor),
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
}
