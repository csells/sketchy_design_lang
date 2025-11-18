// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';
import '../theme/sketchy_theme.dart';

/// Wired slider.
///
/// ```dart
/// Container(
/// 	padding: EdgeInsets.all(25.0),
/// 	height: 200.0,
/// 	child: SketchySlider(
/// 	  value: _currentSliderValue,
/// 	  min: 0,
/// 	  max: 100,
/// 	  divisions: 5,
/// 	  label: _currentSliderValue.round().toString(),
/// 	  onChanged: (double value) {
/// 		setState(() {
/// 		  _currentSliderValue = value;
/// 		});
/// 		print('$_currentSliderValue');
/// 		return true;
/// 	  },
/// 	),
///   ),
/// ```
class SketchySlider extends StatefulWidget {
  const SketchySlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.divisions,
    this.label,
    this.min = 0.0,
    this.max = 1.0,
  });

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// The number of discrete divisions.
  ///
  /// Typically used with [label] to show the current discrete value.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// A label to show above the slider when the slider is active.
  final String? label;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double max;

  /// Called during a drag when the user is selecting a new value for the slider.
  final ValueChanged<double>? onChanged;

  @override
  _SketchySliderState createState() => _SketchySliderState();
}

class _SketchySliderState extends State<SketchySlider> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.value;

    // Delay for calculate the slider's width `_getSliderWidth()` during the next frame
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 1,
          width: double.infinity,
          child: WiredCanvas(
            painter: WiredLineBase(
              x1: 0,
              y1: 0,
              x2: double.infinity,
              y2: 0,
              strokeWidth: theme.strokeWidth,
              color: theme.borderColor,
            ),
            fillerType: RoughFilter.HatchFiller,
          ),
        ),
        Positioned(
          left: _getWidth() * _currentSliderValue / widget.max - 12,
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
        SliderTheme(
          data: SliderThemeData(trackShape: CustomTrackShape()),
          child: Slider(
            value: _currentSliderValue,
            min: widget.min,
            max: widget.max,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
            divisions: widget.divisions,
            label: widget.label,
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
      ],
    );
  }

  double _getWidth() {
    double width = 0;
    try {
      final box = context.findRenderObject()! as RenderBox;
      width = box.size.width;
    } catch (e) {}

    return width;
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight!;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
