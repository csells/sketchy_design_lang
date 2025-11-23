import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DateTime _selectedDate = DateTime(2021, 7, 22);

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy calendar',
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedDate.year} - '
            '${_selectedDate.month.toString().padLeft(2, '0')} - '
            '${_selectedDate.day.toString().padLeft(2, '0')}',
            style: fieldLabelStyle(theme),
          ),
          const SizedBox(height: 8),
          SizedBox(
            child: SketchyCalendar(
              selected: _selectedDate,
              onSelected: (date) => setState(() => _selectedDate = date),
            ),
          ),
        ],
      ),
    ),
  );
}
