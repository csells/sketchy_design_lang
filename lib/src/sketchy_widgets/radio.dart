// ignore_for_file: public_member_api_docs
import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Sketchy radio button group.
///
/// Usage:
/// ```dart
/// ListTile(
/// title: const Text('Lafayette'),
/// leading: SketchyRadio<SingingCharacter>(
///   value: SingingCharacter.lafayette,
///   groupValue: _character,
///   onChanged: (SingingCharacter? value) {
/// 	print('$value');
/// 	setState(() {
/// 	  _character = value;
/// 	});
///
/// 	return true;
///   },
/// ),
/// ),
/// ```
class SketchyRadio<T> extends StatefulWidget {
  const SketchyRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  /// The value for radio.
  final T value;

  /// The current group radios value.
  final T? groupValue;

  /// Called when the radio value changes.
  final ValueChanged<T?>? onChanged;

  @override
  State<SketchyRadio<T>> createState() => _SketchyRadioState<T>();
}

// ignore: library_private_types_in_public_api
class _SketchyRadioState<T> extends State<SketchyRadio<T>> {
  bool _isSelected = false;
  T? _groupValue;

  @override
  Widget build(BuildContext context) {
    _groupValue = widget.groupValue;
    _isSelected = _groupValue == widget.value;
    final theme = SketchyTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: SizedBox(
        height: 48,
        width: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SketchyFrame(
              width: 36,
              height: 36,
              shape: SketchyFrameShape.circle,
              fill: SketchyFill.none,
              child: SizedBox.expand(),
            ),
            AnimatedOpacity(
              opacity: _isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: SketchyFrame(
                width: 20,
                height: 20,
                shape: SketchyFrameShape.circle,
                fill: SketchyFill.solid,
                fillColor: theme.colors.ink,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap() => widget.onChanged?.call(widget.value);
}
