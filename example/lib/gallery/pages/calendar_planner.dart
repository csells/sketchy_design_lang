import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Planner example highlighting the sketchy calendar.
class SketchyCalendarPlannerExample extends StatefulWidget {
  const SketchyCalendarPlannerExample({super.key});

  static Widget builder(BuildContext context) =>
      const SketchyCalendarPlannerExample();

  @override
  State<SketchyCalendarPlannerExample> createState() =>
      _SketchyCalendarPlannerExampleState();
}

class _SketchyCalendarPlannerExampleState
    extends State<SketchyCalendarPlannerExample> {
  DateTime _selected = DateTime.now();

  final List<String> _agenda = [
    'Wireframe review with product',
    'Customer interview playback',
    'Design debt swarm',
  ];

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Studio Scheduler')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: SketchyCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pick a review slot', style: typography.headline),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 320,
                        child: SketchyCalendar(
                          selected: _selected,
                          onSelected: (value) =>
                              setState(() => _selected = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: SketchyCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM d').format(_selected),
                        style: typography.title,
                      ),
                      const SizedBox(height: 16),
                      for (final item in _agenda) ...[
                        SketchyListTile(
                          title: Text(item),
                          subtitle: const Text('Prep notes ready.'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 8),
                      SketchyButton(
                        onPressed: () {},
                        child: Text('Send invites', style: typography.label),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
