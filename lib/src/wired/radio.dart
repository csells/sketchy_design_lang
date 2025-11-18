// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';
import '../theme/sketchy_theme.dart';

/// Wired radio.
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
  _SketchyRadioState<T> createState() => _SketchyRadioState<T>();
}

class _SketchyRadioState<T> extends State<SketchyRadio<T>> {
  bool _isSelected = false;
  T? _groupValue;

  @override
  Widget build(BuildContext context) {
    _groupValue = widget.groupValue;
    _isSelected = _groupValue == widget.value;
    final theme = SketchyTheme.of(context);
    return SizedBox(
      height: 48,
      width: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleTap,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 48,
                width: 48,
                child: WiredCanvas(
                  painter: WiredCircleBase(
                    diameterRatio: .7,
                    strokeColor: theme.borderColor,
                  ),
                  fillerType: RoughFilter.NoFiller,
                ),
              ),
            ),
            if (_isSelected)
              Positioned(
                left: 12,
                top: 12,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: WiredCanvas(
                    painter: WiredCircleBase(
                      diameterRatio: .7,
                      fillColor: theme.textColor,
                      strokeColor: theme.textColor,
                    ),
                    fillerType: RoughFilter.HachureFiller,
                    fillerConfig: FillerConfig.build(hachureGap: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleTap() => widget.onChanged?.call(widget.value);
}
