import 'package:flutter/widgets.dart';

import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'calendar_utils.dart';
import 'sketchy_frame.dart';
import 'text.dart';

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
  const SketchyCalendar({
    super.key,
    this.selected,
    this.onSelected,
    this.textCase,
  });

  /// The date to be selected.
  final DateTime? selected;

  /// Called when the selected date changed.
  final ValueChanged<DateTime>? onSelected;

  /// Text casing transformation for month/year and weekday headers. If null,
  /// uses theme default. Note: This does NOT affect date numbers.
  final TextCase? textCase;

  @override
  State<SketchyCalendar> createState() => _SketchyCalendarState();
}

class _SketchyCalendarState extends State<SketchyCalendar> {
  DateTime _firstOfMonthDate = DateTime.now();
  List<CalendarCell> _cells = [];
  String _monthYear = '';

  DateTime? _selected;
  SketchyThemeData? _previousTheme;

  @override
  void initState() {
    super.initState();

    _initParams();
  }

  @override
  void didUpdateWidget(SketchyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _selected = widget.selected;
    }
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final themeChanged = !identical(_previousTheme, theme);
      if (_previousTheme == null || themeChanged) {
        _previousTheme = theme;
        _refresh(theme);
      }

      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildWeekdaysNav(theme),
            const SizedBox(height: 20),
            _buildWeeksHeaderUI(theme),
            _buildWeekdaysUI(theme),
          ],
        ),
      );
    },
  );

  void _refresh(SketchyThemeData theme) {
    _setInitialConditions();
    _computeCalendar(theme);
  }

  Padding _buildWeekdaysNav(SketchyThemeData theme) {
    final casing = widget.textCase ?? theme.textCase;
    final displayMonthYear = applyTextCase(_monthYear, casing);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _onPre(theme),
            child: _sketchyText(
              theme,
              '<<',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          _sketchyText(
            theme,
            displayMonthYear,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          GestureDetector(
            onTap: () => _onNext(theme),
            child: _sketchyText(
              theme,
              '>>',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  void _onPre(SketchyThemeData theme) {
    _firstOfMonthDate = getPreviousMonth(_firstOfMonthDate);
    _computeCalendar(theme);
    setState(() {});
  }

  void _onNext(SketchyThemeData theme) {
    _firstOfMonthDate = getNextMonth(_firstOfMonthDate);
    _computeCalendar(theme);
    setState(() {});
  }

  Row _buildWeeksHeaderUI(SketchyThemeData theme) {
    final casing = widget.textCase ?? theme.textCase;
    final headers = <Widget>[];
    for (final weekday in weekdaysShort) {
      final displayWeekday = applyTextCase(weekday, casing);
      headers.add(
        _buildCell(
          theme,
          displayWeekday,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: headers,
    );
  }

  Widget _buildWeekdaysUI(SketchyThemeData theme) {
    final weekdays = <Widget>[];
    for (final cell in _cells) {
      weekdays.add(
        GestureDetector(
          onTap: () {
            if (isSameDay(_selected, cell.value)) return;
            _selected = cell.value;
            _refresh(theme);
            setState(() {});

            if (widget.onSelected != null) {
              widget.onSelected?.call(cell.value);
            }
          },
          child: _buildCell(
            theme,
            cell.text,
            selected: cell.selected,
            color: cell.color,
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: weekdays,
    );
  }

  void _initParams() {
    _selected = widget.selected;
  }

  void _setInitialConditions() {
    final reference = _selected ?? DateTime.now();
    _firstOfMonthDate = getFirstOfMonth(reference);
  }

  void _computeCalendar(SketchyThemeData theme) {
    _monthYear = formatMonthYear(_firstOfMonthDate);
    _cells = computeCalendarCells(
      firstOfMonth: _firstOfMonthDate,
      selectedDate: _selected,
      inkColor: theme.inkColor,
    );
  }

  RenderObjectWidget _buildCell(
    SketchyThemeData theme,
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
        theme,
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
            strokeColor: theme.borderColor,
            child: const SizedBox.expand(),
          ),
          content,
        ],
      ),
    );
  }

  SketchyText _sketchyText(
    SketchyThemeData theme,
    String text, {
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 18.0,
    Color? color,
  }) => SketchyText(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: theme.fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? theme.inkColor,
    ),
  );
}
