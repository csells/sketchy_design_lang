// benchmark/circular_progress_benchmark.dart
// ignore_for_file: avoid_print, lines_longer_than_80_chars
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
// ignore_for_file: unreachable_from_main, unnecessary_statements
//
// Pure Dart performance benchmarks for SketchyCircularProgressIndicator primitives.
//
// Run with:
//   dart run benchmark/circular_progress_benchmark.dart
//
// Note: This benchmark tests the primitive/generator layer only.
// For visual/rendering benchmarks, use the example app.

import 'dart:math' show Random, pi;

// Since we can't import Flutter in pure Dart, we'll create minimal
// representations of the types we need to benchmark.

void main() {
  print('=' * 70);
  print('SKETCHY CIRCULAR PROGRESS INDICATOR - PERFORMANCE BENCHMARKS');
  print('=' * 70);
  print('');
  print('Note: These benchmarks test the computational layer only.');
  print('For rendering benchmarks, run the example app in profile mode.');
  print('');

  benchmarkPrimitiveDataCreation();
  benchmarkHashCodeComputation();
  benchmarkEqualityComparison();
  benchmarkAngleCalculations();
  benchmarkMemoryPattern();

  print('');
  print('=' * 70);
  print('BENCHMARKS COMPLETE');
  print('=' * 70);
}

// ============================================================================
// Minimal type representations for benchmarking
// ============================================================================

enum SketchyShapeType { rectangle, roundedRectangle, circle, arc }

enum SketchyFill { none, hachure, solid }

class SketchyFillOptions {
  const SketchyFillOptions({this.hachureGap, this.fillWeight});
  final double? hachureGap;
  final double? fillWeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchyFillOptions &&
          hachureGap == other.hachureGap &&
          fillWeight == other.fillWeight;

  @override
  int get hashCode => hachureGap.hashCode ^ fillWeight.hashCode;
}

class SketchyPrimitive {
  const SketchyPrimitive({
    required this.type,
    required this.seed,
    this.fill = SketchyFill.none,
    this.fillOptions,
    this.cornerRadius = 0,
    this.startAngle,
    this.sweepAngle,
  });

  factory SketchyPrimitive.circle({
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive(
    type: SketchyShapeType.circle,
    fill: fill,
    fillOptions: fillOptions,
    seed: seed ?? _seedSource.nextInt(0x7fffffff),
  );

  factory SketchyPrimitive.arc({
    required double startAngle,
    required double sweepAngle,
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive(
    type: SketchyShapeType.arc,
    fill: fill,
    fillOptions: fillOptions,
    seed: seed ?? _seedSource.nextInt(0x7fffffff),
    startAngle: startAngle,
    sweepAngle: sweepAngle,
  );

  final SketchyShapeType type;
  final SketchyFill fill;
  final SketchyFillOptions? fillOptions;
  final double cornerRadius;
  final double? startAngle;
  final double? sweepAngle;
  final int seed;

  static final Random _seedSource = Random();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchyPrimitive &&
          type == other.type &&
          fill == other.fill &&
          fillOptions == other.fillOptions &&
          cornerRadius == other.cornerRadius &&
          startAngle == other.startAngle &&
          sweepAngle == other.sweepAngle &&
          seed == other.seed;

  @override
  int get hashCode =>
      type.hashCode ^
      fill.hashCode ^
      fillOptions.hashCode ^
      cornerRadius.hashCode ^
      startAngle.hashCode ^
      sweepAngle.hashCode ^
      seed.hashCode;
}

// ============================================================================
// Benchmarks
// ============================================================================

void benchmarkPrimitiveDataCreation() {
  print('--- Primitive Creation Benchmark ---');
  print('');

  const iterations = 100000;

  // Benchmark circle primitive creation
  final circleStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    SketchyPrimitive.circle(seed: 12345);
  }
  circleStopwatch.stop();

  // Benchmark arc primitive creation
  final arcStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    SketchyPrimitive.arc(seed: 12345, startAngle: -pi / 2, sweepAngle: pi);
  }
  arcStopwatch.stop();

  // Benchmark arc with varying angles (simulates animation)
  final varyingArcStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final angle = (i / iterations) * 2 * pi;
    SketchyPrimitive.arc(
      seed: 12345,
      startAngle: -pi / 2 + angle,
      sweepAngle: 0.75 * 2 * pi,
    );
  }
  varyingArcStopwatch.stop();

  _printResult('Circle primitive', iterations, circleStopwatch);
  _printResult('Arc primitive (fixed)', iterations, arcStopwatch);
  _printResult('Arc primitive (varying)', iterations, varyingArcStopwatch);
  print('');
}

void benchmarkHashCodeComputation() {
  print('--- HashCode Computation Benchmark ---');
  print('');

  const iterations = 100000;

  final circlePrimitive = SketchyPrimitive.circle(seed: 12345);
  final arcPrimitive = SketchyPrimitive.arc(
    seed: 12345,
    startAngle: -pi / 2,
    sweepAngle: pi,
  );

  // Circle hashCode
  final circleStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    circlePrimitive.hashCode;
  }
  circleStopwatch.stop();

  // Arc hashCode
  final arcStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    arcPrimitive.hashCode;
  }
  arcStopwatch.stop();

  // Arc hashCode with new primitives each time (simulates cache key generation)
  final newArcStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final angle = (i / iterations) * 2 * pi;
    final primitive = SketchyPrimitive.arc(
      seed: 12345,
      startAngle: -pi / 2 + angle,
      sweepAngle: 0.75 * 2 * pi,
    );
    primitive.hashCode;
  }
  newArcStopwatch.stop();

  _printResult('Circle hashCode', iterations, circleStopwatch);
  _printResult('Arc hashCode (same)', iterations, arcStopwatch);
  _printResult('Arc hashCode (new each)', iterations, newArcStopwatch);
  print('');
}

void benchmarkEqualityComparison() {
  print('--- Equality Comparison Benchmark ---');
  print('');

  const iterations = 100000;

  final circle1 = SketchyPrimitive.circle(seed: 12345);
  final circle2 = SketchyPrimitive.circle(seed: 12345);
  final arc1 = SketchyPrimitive.arc(
    seed: 12345,
    startAngle: -pi / 2,
    sweepAngle: pi,
  );
  final arc2 = SketchyPrimitive.arc(
    seed: 12345,
    startAngle: -pi / 2,
    sweepAngle: pi,
  );

  // Circle equality (same)
  final circleSameStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    circle1 == circle2;
  }
  circleSameStopwatch.stop();

  // Arc equality (same)
  final arcSameStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    arc1 == arc2;
  }
  arcSameStopwatch.stop();

  // Arc equality (different angles - typical animation scenario)
  final arcDiffStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final angle = (i / iterations) * 2 * pi;
    final newArc = SketchyPrimitive.arc(
      seed: 12345,
      startAngle: -pi / 2 + angle,
      sweepAngle: 0.75 * 2 * pi,
    );
    arc1 == newArc;
  }
  arcDiffStopwatch.stop();

  _printResult('Circle == Circle (same)', iterations, circleSameStopwatch);
  _printResult('Arc == Arc (same)', iterations, arcSameStopwatch);
  _printResult('Arc == Arc (different)', iterations, arcDiffStopwatch);
  print('');
}

void benchmarkAngleCalculations() {
  print('--- Angle Calculation Benchmark (Animation Simulation) ---');
  print('');

  const iterations = 100000;

  // Simulates the angle calculations done per frame in indeterminate mode
  final spinStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final t = (i % 120) / 120; // 2 second cycle at 60fps
    final spinOffset = t * 2 * pi;
    final startAngle = -pi / 2 + spinOffset;
    const sweepAngle = 0.75 * 2 * pi;
    // Use values to prevent optimization
    if (startAngle > 100 && sweepAngle > 100) print('never');
  }
  spinStopwatch.stop();

  // Simulates determinate mode calculations
  final determinateStopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final value = (i % 100) / 100;
    const startAngle = -pi / 2;
    final sweepAngle = value * 2 * pi;
    if (startAngle > 100 && sweepAngle > 100) print('never');
  }
  determinateStopwatch.stop();

  _printResult('Spin angle calc (indeterminate)', iterations, spinStopwatch);
  _printResult(
    'Sweep angle calc (determinate)',
    iterations,
    determinateStopwatch,
  );
  print('');
}

void benchmarkMemoryPattern() {
  print('--- Memory Pattern Benchmark ---');
  print('');

  const iterations = 10000;

  // Pattern 1: Create new primitive each frame (BAD - what we want to avoid)
  final newEachFrameStopwatch = Stopwatch()..start();
  final primitives1 = <SketchyPrimitive>[];
  for (var i = 0; i < iterations; i++) {
    primitives1.add(SketchyPrimitive.circle(seed: 12345));
  }
  newEachFrameStopwatch.stop();

  // Pattern 2: Reuse cached primitive (GOOD - what we do for background)
  final cachedPrimitive = SketchyPrimitive.circle(seed: 12345);
  final reuseStopwatch = Stopwatch()..start();
  final primitives2 = <SketchyPrimitive>[];
  for (var i = 0; i < iterations; i++) {
    primitives2.add(cachedPrimitive);
  }
  reuseStopwatch.stop();

  // Pattern 3: Arc with changing angles (UNAVOIDABLE for animation)
  final arcChangingStopwatch = Stopwatch()..start();
  final primitives3 = <SketchyPrimitive>[];
  for (var i = 0; i < iterations; i++) {
    final angle = (i / iterations) * 2 * pi;
    primitives3.add(
      SketchyPrimitive.arc(
        seed: 12345,
        startAngle: -pi / 2 + angle,
        sweepAngle: 0.75 * 2 * pi,
      ),
    );
  }
  arcChangingStopwatch.stop();

  _printResult(
    'New circle each frame (BAD)',
    iterations,
    newEachFrameStopwatch,
  );
  _printResult('Reuse cached circle (GOOD)', iterations, reuseStopwatch);
  _printResult(
    'Arc with new angles (necessary)',
    iterations,
    arcChangingStopwatch,
  );

  final speedup =
      newEachFrameStopwatch.elapsedMicroseconds /
      reuseStopwatch.elapsedMicroseconds;
  print('');
  print('  >> Caching speedup: ${speedup.toStringAsFixed(1)}x faster');
  print('');
}

void _printResult(String name, int iterations, Stopwatch stopwatch) {
  final totalUs = stopwatch.elapsedMicroseconds;
  final perOpUs = totalUs / iterations;
  final perOpNs = perOpUs * 1000;

  String perOpStr;
  if (perOpNs < 1000) {
    perOpStr = '${perOpNs.toStringAsFixed(1)}ns/op';
  } else {
    perOpStr = '${perOpUs.toStringAsFixed(2)}µs/op';
  }

  print('  $name:');
  print(
    '    Total: ${_formatMicroseconds(totalUs)} for $iterations iterations',
  );
  print('    Per-op: $perOpStr');
}

String _formatMicroseconds(int us) {
  if (us < 1000) {
    return '$usµs';
  } else if (us < 1000000) {
    return '${(us / 1000).toStringAsFixed(2)}ms';
  } else {
    return '${(us / 1000000).toStringAsFixed(2)}s';
  }
}
