import 'package:flutter/widgets.dart';

/// Mixin that synchronizes a widget property value with a state field.
///
/// This eliminates the common pattern of syncing widget.value with _value:
/// - Initializes _syncedValue from widget.value in initState
/// - Updates _syncedValue when widget.value changes in didUpdateWidget
/// - Provides updateValue() helper for user interactions
///
/// Usage:
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with ValueSyncMixin<bool, MyWidget> {
///   @override
///   bool get widgetValue => widget.value;
///
///   @override
///   bool getOldWidgetValue(MyWidget oldWidget) => oldWidget.value;
///
///   @override
///   Widget build(BuildContext context) {
///     // Use 'value' instead of '_value'
///     return GestureDetector(
///       onTap: () {
///         updateValue(!value);
///         widget.onChanged(value);
///       },
///       // ...
///     );
///   }
/// }
/// ```
mixin ValueSyncMixin<T, W extends StatefulWidget> on State<W> {
  late T _syncedValue;

  /// The current widget's value to sync.
  T get widgetValue;

  /// Gets the old widget's value for comparison during updates.
  T getOldWidgetValue(W oldWidget);

  /// The synchronized value maintained in state.
  T get value => _syncedValue;

  @override
  void initState() {
    super.initState();
    _syncedValue = widgetValue;
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldValue = getOldWidgetValue(oldWidget);
    if (oldValue != widgetValue) {
      _syncedValue = widgetValue;
    }
  }

  /// Updates the synchronized value and triggers a rebuild.
  void updateValue(T newValue) {
    setState(() {
      _syncedValue = newValue;
    });
  }
}
