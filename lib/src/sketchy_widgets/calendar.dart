import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/calendar_utils.dart';
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
  DateTime _firstOfMonthDate = DateTime.now();
  List<CalendarCell> _cells = [];
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
    _firstOfMonthDate = getPreviousMonth(_firstOfMonthDate);
    _computeCalendar();
    setState(() {});
  }

  void _onNext() {
    _firstOfMonthDate = getNextMonth(_firstOfMonthDate);
    _computeCalendar();
    setState(() {});
  }

  Row _buildWeeksHeaderUI() {
    final headers = <Widget>[];
    for (final weekday in weekdaysShort) {
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
    for (final cell in _cells) {
      weekdays.add(
        GestureDetector(
          onTap: () {
            if (isSameDay(_selected, cell.value)) return;
            _selected = cell.value;
            _refresh();
            setState(() {});

            if (widget.onSelected != null) {
              widget.onSelected!(cell.value);
            }
          },
          child: _buildCell(
            cell.text,
            selected: cell.selected,
            color: cell.color,
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
    _firstOfMonthDate = getFirstOfMonth(reference);
  }

  void _computeCalendar() {
    _monthYear = formatMonthYear(_firstOfMonthDate);
    _cells = computeCalendarCells(
      firstOfMonth: _firstOfMonthDate,
      selectedDate: _selected,
      inkColor: _theme.colors.ink,
    );
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
