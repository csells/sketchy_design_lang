import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Sketchy calendar.
///
/// Usage:
/// ```dart
/// Container(
/// 	color: Colors.grey.shade200,
/// 	padding: EdgeInsets.all(15.0),
/// 	height: 460.0,
/// 	child: SketchyCalendar(
/// 	selected: '20210722',
/// 	onSelected: (value) {
/// 		print('Selected date: $value');
/// 		},
/// 	),
/// )
/// ```
class SketchyCalendar extends StatefulWidget {
  /// Creates a sketchy-styled calendar optionally pre-selecting [selected].
  const SketchyCalendar({super.key, this.selected, this.onSelected});

  /// The date to be selected.
  final DateTime? selected;

  /// Called when the selected date changed.
  final ValueChanged<DateTime>? onSelected;

  @override
  State<SketchyCalendar> createState() => _SketchyCalendarState();
}

class _SketchyCalendarState extends State<SketchyCalendar> {
  final _weekdaysShort = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  DateTime _firstOfMonthDate = DateTime.now();
  final List<CalendarCell> _weeks = [];
  String _monthYear = '';

  DateTime? _selected;
  late SketchyThemeData _theme;
  bool _didInitTheme = false;

  @override
  void initState() {
    super.initState();

    _initParams();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newTheme = SketchyTheme.of(context);
    final shouldRefresh = !_didInitTheme || !identical(newTheme, _theme);
    final isInitialPass = !_didInitTheme;
    _theme = newTheme;

    if (shouldRefresh) {
      _refresh();
    }
    if (isInitialPass) {
      _didInitTheme = true;
    } else if (shouldRefresh) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        _buildWeekdaysNav(),
        const SizedBox(height: 20),
        _buildWeeksHeaderUI(),
        Expanded(child: _buildWeekdaysUI()),
      ],
    ),
  );

  void _refresh() {
    _setInitialConditions();
    _computeCalendar();
  }

  Padding _buildWeekdaysNav() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _onPre,
          child: _sketchyText('<<', fontWeight: FontWeight.bold, fontSize: 24),
        ),
        _sketchyText(_monthYear, fontWeight: FontWeight.bold, fontSize: 22),
        GestureDetector(
          onTap: _onNext,
          child: _sketchyText('>>', fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ],
    ),
  );

  void _onPre() {
    _firstOfMonthDate = DateTime(
      _firstOfMonthDate.year,
      _firstOfMonthDate.month - 1,
      1,
    );
    _computeCalendar();
    setState(() {});
  }

  void _onNext() {
    _firstOfMonthDate = DateTime(
      _firstOfMonthDate.year,
      _firstOfMonthDate.month + 1,
      1,
    );
    _computeCalendar();
    setState(() {});
  }

  Row _buildWeeksHeaderUI() {
    final headers = <Widget>[];
    for (final weekday in _weekdaysShort) {
      headers.add(
        _buildCell(weekday, fontWeight: FontWeight.bold, fontSize: 18),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: headers,
    );
  }

  GridView _buildWeekdaysUI() {
    final weekdays = <Widget>[];
    for (final week in _weeks) {
      weekdays.add(
        GestureDetector(
          onTap: () {
            if (_selected == week.value) return;
            _selected = week.value;
            _refresh();
            setState(() {});

            if (widget.onSelected != null) {
              widget.onSelected!(week.value);
            }
          },
          child: _buildCell(
            week.text,
            selected: week.selected,
            color: week.color,
          ),
      ),
      );
    }

    return GridView.count(crossAxisCount: 7, children: [...weekdays]);
  }

  void _initParams() {
    _selected = widget.selected;
  }

  void _setInitialConditions() {
    final reference = _selected ?? DateTime.now();
    _firstOfMonthDate = DateTime(reference.year, reference.month, 1);
  }

  void _computeCalendar() {
    _monthYear =
        '${_months[_firstOfMonthDate.month - 1]} ${_firstOfMonthDate.year}';

    final firstDayInMonth = DateTime(
      _firstOfMonthDate.year,
      _firstOfMonthDate.month,
      1,
    );
    var dayInMonthOffset = 0 - (firstDayInMonth.weekday % 7);
    final amountOfWeeks =
        (DateTime(_firstOfMonthDate.year, _firstOfMonthDate.month + 1, 0).day -
            dayInMonthOffset) /
        7;

    _weeks.clear();
    for (var weekIndex = 0; weekIndex < amountOfWeeks; weekIndex++) {
      for (var dayOfWeekIndex = 0; dayOfWeekIndex < 7; dayOfWeekIndex++) {
        final day = DateTime.fromMillisecondsSinceEpoch(
          firstDayInMonth.millisecondsSinceEpoch +
              _kMillisecondsPerDay * dayInMonthOffset,
        );
        final isSelected =
            _selected != null &&
            day.year == _selected!.year &&
            day.month == _selected!.month &&
            day.day == _selected!.day;

        _weeks.add(
          CalendarCell(
            value: day,
            text: day.day.toString(),
            selected: isSelected,
            dimmed: day.month != firstDayInMonth.month,
            color: day.month == firstDayInMonth.month
                ? _theme.colors.ink
                : _theme.colors.ink.withValues(alpha: 0.35),
            disabled: false,
          ),
        );

        dayInMonthOffset++;
      }
    }
  }

  RenderObjectWidget _buildCell(
    String text, {
    bool selected = false,
    double width = 45.0,
    double height = 50.0,
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 20.0,
    Color? color,
  }) {
    final content = Center(
      child: _sketchyText(
        text,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
    if (!selected) {
      return SizedBox(width: width, height: height, child: content);
    }
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SketchyFrame(
            width: width * 0.75,
            height: height * 0.75,
            shape: SketchyFrameShape.circle,
            fill: SketchyFill.none,
            strokeColor: _theme.borderColor,
            child: const SizedBox.expand(),
          ),
          content,
        ],
      ),
    );
  }

  Text _sketchyText(
    String text, {
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 18.0,
    Color? color,
  }) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: _theme.fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? _theme.colors.ink,
    ),
  );
}

// GLOBAL CONSTANTS
const int _kMillisecondsPerDay = 24 * 60 * 60 * 1000;

/// Model describing a single day rendered within the calendar grid.
class CalendarCell {
  /// Creates a calendar cell to describe the date [value].
  CalendarCell({
    required this.value,
    required this.text,
    required this.selected,
    required this.dimmed,
    required this.color,
    this.disabled = false,
  });

  /// Concrete date represented by this cell.
  final DateTime value;

  /// Label rendered for the day (typically the day number).
  final String text;

  /// Whether the cell is the currently selected day.
  final bool selected;

  /// Whether the day belongs to the visible month.
  final bool dimmed;

  /// Whether selection/input is disabled for the cell.
  final bool disabled;

  /// Color used when painting the label.
  final Color color;
}
