// ignore_for_file: public_member_api_docs, constant_identifier_names

import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../../theme/sketchy_theme.dart';
import 'wired_painter.dart';
import 'wired_painter_base.dart';

class WiredCanvas extends StatelessWidget {
  const WiredCanvas({
    required this.painter,
    required this.fillerType,
    super.key,
    this.drawConfig,
    this.fillerConfig,
    this.size,
  });
  final WiredPainterBase painter;
  final DrawConfig? drawConfig;
  final FillerConfig? fillerConfig;
  final RoughFilter fillerType;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    final wiredTheme = SketchyTheme.of(context);
    final baseConfig = drawConfig ?? DrawConfig.defaultValues;
    final mappedRoughness =
        lerpDouble(0.25, 2.1, wiredTheme.roughness) ?? wiredTheme.roughness;
    final mappedRandomness =
        lerpDouble(0.6, 3.6, wiredTheme.roughness) ?? wiredTheme.roughness;
    final effectiveDrawConfig = baseConfig.copyWith(
      roughness: mappedRoughness,
      maxRandomnessOffset: mappedRandomness,
      randomizer: Randomizer(seed: Random().nextInt(1 << 31)),
    );
    final effectiveFillerConfig = fillerConfig ?? FillerConfig.defaultConfig;

    final filler = _filters[fillerType]!.call(effectiveFillerConfig);
    return CustomPaint(
      size: size == null ? Size.infinite : size!,
      painter: WiredPainter(effectiveDrawConfig, filler, painter, wiredTheme),
    );
  }
}

Map<RoughFilter, Filler Function(FillerConfig)> _filters =
    <RoughFilter, Filler Function(FillerConfig)>{
      RoughFilter.NoFiller: NoFiller.new,
      RoughFilter.HachureFiller: HachureFiller.new,
      RoughFilter.ZigZagFiller: ZigZagFiller.new,
      RoughFilter.HatchFiller: HatchFiller.new,
      RoughFilter.DotFiller: DotFiller.new,
      RoughFilter.DashedFiller: DashedFiller.new,
      RoughFilter.SolidFiller: SolidFiller.new,
    };

enum RoughFilter {
  NoFiller,
  HachureFiller,
  ZigZagFiller,
  HatchFiller,
  DotFiller,
  DashedFiller,
  SolidFiller,
}
