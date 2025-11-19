/// Utilities for calendar date calculations.
library;

import 'package:flutter/widgets.dart';

const int _kMillisecondsPerDay = 24 * 60 * 60 * 1000;

/// Month names for display.
const List<String> monthNames = [
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

/// Weekday abbreviations for display.
const List<String> weekdaysShort = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

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

/// Formats a date as "Month Year" (e.g., "January 2025").
String formatMonthYear(DateTime date) =>
    '${monthNames[date.month - 1]} ${date.year}';

/// Gets the first day of the month for the given date.
DateTime getFirstOfMonth(DateTime date) =>
    DateTime(date.year, date.month, 1);

/// Gets the first day of the next month.
DateTime getNextMonth(DateTime currentFirstOfMonth) => DateTime(
      currentFirstOfMonth.year,
      currentFirstOfMonth.month + 1,
      1,
    );

/// Gets the first day of the previous month.
DateTime getPreviousMonth(DateTime currentFirstOfMonth) => DateTime(
      currentFirstOfMonth.year,
      currentFirstOfMonth.month - 1,
      1,
    );

/// Calculates the day offset needed to align the calendar grid.
///
/// Returns a negative offset representing how many days before the 1st
/// of the month should be displayed to align the grid with weekdays.
int calculateDayOffset(DateTime firstOfMonth) =>
    0 - (firstOfMonth.weekday % 7);

/// Calculates the number of weeks needed to display the month.
int calculateWeekCount(DateTime firstOfMonth) {
  final dayOffset = calculateDayOffset(firstOfMonth);
  final lastDayOfMonth =
      DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0).day;
  final totalDays = lastDayOfMonth - dayOffset;
  return (totalDays / 7).ceil();
}

/// Checks if two dates represent the same day.
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Computes all calendar cells for the given month.
///
/// Returns a list of [CalendarCell] objects representing each day in the
/// calendar grid, including days from adjacent months for alignment.
List<CalendarCell> computeCalendarCells({
  required DateTime firstOfMonth,
  required DateTime? selectedDate,
  required Color inkColor,
}) {
  final cells = <CalendarCell>[];
  final dayOffset = calculateDayOffset(firstOfMonth);
  final weekCount = calculateWeekCount(firstOfMonth);

  for (var weekIndex = 0; weekIndex < weekCount; weekIndex++) {
    for (var dayOfWeekIndex = 0; dayOfWeekIndex < 7; dayOfWeekIndex++) {
      final currentOffset = (weekIndex * 7) + dayOfWeekIndex + dayOffset;
      final day = DateTime.fromMillisecondsSinceEpoch(
        firstOfMonth.millisecondsSinceEpoch +
            _kMillisecondsPerDay * currentOffset,
      );

      final isSelected = isSameDay(day, selectedDate);
      final isCurrentMonth = day.month == firstOfMonth.month;

      cells.add(
        CalendarCell(
          value: day,
          text: day.day.toString(),
          selected: isSelected,
          dimmed: !isCurrentMonth,
          color: isCurrentMonth
              ? inkColor
              : inkColor.withValues(alpha: 0.35),
          disabled: false,
        ),
      );
    }
  }

  return cells;
}
