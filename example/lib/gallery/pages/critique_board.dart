import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Gallery grid demonstrating badges + hover annotations.
class CollaborativeCritiqueBoardExample extends StatelessWidget {
  const CollaborativeCritiqueBoardExample({super.key});

  static Widget builder(BuildContext context) =>
      const CollaborativeCritiqueBoardExample();

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    final colors = SketchyTheme.of(context).colors;

    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Critique Board')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
          children: List.generate(
            6,
            (index) => SketchyCard(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.paper,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SketchyBadge(
                      label: 'v${index + 1}',
                      tone: index.isEven
                          ? SketchyBadgeTone.info
                          : SketchyBadgeTone.accent,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile shell concept #$index',
                          style: typography.title,
                        ),
                        const SizedBox(height: 4),
                        SketchyAnnotate.circle(
                          label: 'Discuss contrast',
                          child: Text(
                            'Need a stronger ink fill here to pop.',
                            style: typography.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
