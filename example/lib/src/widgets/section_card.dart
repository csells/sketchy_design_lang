import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.height,
    super.key,
  });

  final String title;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => Card(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle(theme)),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}
