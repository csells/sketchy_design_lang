// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'package:rough_flutter/rough_flutter.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';

/// Wired combo
///
/// Usage:
/// ```dart
/// SketchyCombo(
///   value: 'One',
///   items: ['One', 'Two', 'Free', 'Four']
/// 	  .map<DropdownMenuItem<String>>((dynamic value) {
/// 	return DropdownMenuItem<String>(
/// 	  value: value,
/// 	  child: Padding(
/// 		padding: EdgeInsets.only(left: 5.0),
/// 		child: WiredText(value),
/// 	  ),
/// 	);
///   }).toList(),
///   onChanged: (value) {
/// 	print('$value');
///   },
/// ),
/// ```
class SketchyCombo extends StatefulWidget {
  const SketchyCombo({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
  });

  /// The selected value for combo.
  final dynamic value;

  /// The selection items for combo.
  final List<DropdownMenuItem<dynamic>> items;

  /// Called when the combo selected value changed.
  final Function(dynamic)? onChanged;

  @override
  _SketchyComboState createState() => _SketchyComboState();
}

class _SketchyComboState extends State<SketchyCombo> {
  final double _height = 60;
  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) => _buildWidget();

  Widget _buildWidget() => Container(
    color: Colors.transparent,
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    height: _height,
    child: Stack(
      children: [
        Positioned(
          right: 10,
          top: 20,
          child: WiredCanvas(
            painter: WiredInvertedTriangleBase(),
            fillerType: RoughFilter.HachureFiller,
            fillerConfig: FillerConfig.build(hachureGap: 2),
            size: const Size(18, 18),
          ),
        ),
        SizedBox(
          height: _height,
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              itemHeight: _height,
              isExpanded: true,
              elevation: 0,
              icon: const Visibility(
                visible: false,
                child: Icon(Icons.arrow_downward),
              ),
              value: _value,
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item.value,
                      child: Stack(
                        children: [
                          WiredCanvas(
                            painter: WiredRectangleBase(),
                            fillerType: RoughFilter.NoFiller,
                            size: Size(double.infinity, _height),
                          ),
                          Positioned(top: 20, child: item.child),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (dynamic value) {
                _value = value;
                if (widget.onChanged != null) {
                  widget.onChanged!(_value);
                }

                setState(() {});
              },
            ),
          ),
        ),
      ],
    ),
  );
}
