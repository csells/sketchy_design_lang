import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Quiz scenario demonstrating chips + progress indicators.
class QuizCardExample extends StatefulWidget {
  const QuizCardExample({super.key});

  static Widget builder(BuildContext context) => const QuizCardExample();

  @override
  State<QuizCardExample> createState() => _QuizCardExampleState();
}

class _QuizCardExampleState extends State<QuizCardExample> {
  final _selected = <int>{};

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);

    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Quiz Card')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SketchyCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question 2 of 5', style: typography.caption),
                const SizedBox(height: 8),
                const SketchyProgressBar(value: 0.4),
                const SizedBox(height: 16),
                Text(
                  'Which statements describe the benefits of sketch-style '
                  'interfaces?',
                  style: typography.title,
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  _answers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SketchyChip.choice(
                      label: _answers[index],
                      selected: _selected.contains(index),
                      onSelected: () {
                        setState(() {
                          if (_selected.contains(index)) {
                            _selected.remove(index);
                          } else {
                            _selected.add(index);
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SketchyAnnotate.highlight(
                  label: 'Celebration',
                  child: SketchyButton.primary(
                    label: 'Check answer',
                    onPressed: _selected.isEmpty ? null : () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _answers = [
  'They invite feedback before pixel-perfect polish.',
  'They run faster than production code.',
  'They keep attention focused on flow over details.',
  'They are always monochrome.',
];
