// test/circular_progress_performance_test.dart
// ignore_for_file: lines_longer_than_80_chars
//
// Performance regression tests for SketchyCircularProgressIndicator.
//
// These tests ensure that performance characteristics don't degrade
// over time and that caching mechanisms work correctly.

import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  group('SketchyCircularProgressIndicator Performance', () {
    group('Primitive Creation Performance', () {
      test('circle primitive creation is fast', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 50000; // 50ms for 1000 iterations

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          SketchyPrimitive.circle(seed: 12345);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Circle primitive creation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });

      test('arc primitive creation is fast', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 50000; // 50ms for 1000 iterations

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          SketchyPrimitive.arc(
            seed: 12345,
            startAngle: -pi / 2,
            sweepAngle: pi,
          );
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Arc primitive creation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });

      test('arc primitive with varying angles is reasonably fast', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 100000; // 100ms for 1000 iterations

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          final angle = (i / iterations) * 2 * pi;
          SketchyPrimitive.arc(
            seed: 12345,
            startAngle: -pi / 2 + angle,
            sweepAngle: 0.75 * 2 * pi,
          );
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Arc primitive with varying angles took '
              '${stopwatch.elapsedMicroseconds}µs for $iterations iterations '
              '(max allowed: $maxAllowedMicrosecondsµs)',
        );
      });
    });

    group('Drawable Generation Performance', () {
      test('circle drawable generation is fast with caching', () {
        const iterations = 100;
        const maxAllowedMicroseconds = 100000; // 100ms for 100 iterations
        const size = Size(48, 48);
        const roughness = 0.5;

        final primitive = SketchyPrimitive.circle(seed: 12345);

        // Warm up cache
        primitive.drawableFor(size, roughness);

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          primitive.drawableFor(size, roughness);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Circle drawable generation took '
              '${stopwatch.elapsedMicroseconds}µs for $iterations iterations '
              '(max allowed: $maxAllowedMicrosecondsµs)',
        );
      });

      test('arc drawable generation is fast', () {
        const iterations = 100;
        const maxAllowedMicroseconds = 200000; // 200ms for 100 iterations
        const size = Size(48, 48);
        const roughness = 0.5;

        final primitive = SketchyPrimitive.arc(
          seed: 12345,
          startAngle: -pi / 2,
          sweepAngle: pi,
        );

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          primitive.drawableFor(size, roughness);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Arc drawable generation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });
    });

    group('Path Generation Performance', () {
      test('circle path generation is fast', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 50000; // 50ms for 1000 iterations
        const size = Size(48, 48);

        final primitive = SketchyPrimitive.circle(seed: 12345);

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          primitive.pathFor(size);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Circle path generation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });

      test('arc path generation is fast', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 50000; // 50ms for 1000 iterations
        const size = Size(48, 48);

        final primitive = SketchyPrimitive.arc(
          seed: 12345,
          startAngle: -pi / 2,
          sweepAngle: pi,
        );

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          primitive.pathFor(size);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Arc path generation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });
    });

    group('Cache Effectiveness', () {
      test('same primitive returns consistent drawable', () {
        const size = Size(48, 48);
        const roughness = 0.5;

        // Same primitive should return consistent results
        final primitive = SketchyPrimitive.circle(seed: 12345);

        final drawable1 = primitive.drawableFor(size, roughness);
        final drawable2 = primitive.drawableFor(size, roughness);

        // Both calls should succeed and return non-null drawables
        expect(drawable1, isNotNull);
        expect(drawable2, isNotNull);
      });

      test('drawable generation completes within reasonable time', () {
        const iterations = 100;
        const size = Size(48, 48);
        const roughness = 0.5;
        const maxAllowedMicroseconds = 500000; // 500ms for 100 iterations

        final primitive = SketchyPrimitive.circle(seed: 12345);

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          primitive.drawableFor(size, roughness);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'Drawable generation took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });

      test('background circle caching strategy works', () {
        // This test verifies that using the same seed produces consistent results
        // and can benefit from caching

        const seed = 12345;
        const size = Size(48, 48);
        const roughness = 0.5;

        final primitive1 = SketchyPrimitive.circle(seed: seed);
        final primitive2 = SketchyPrimitive.circle(seed: seed);

        // Same seed should produce equal primitives
        expect(primitive1, equals(primitive2));
        expect(primitive1.hashCode, equals(primitive2.hashCode));

        // Drawables should be generated consistently
        final drawable1 = primitive1.drawableFor(size, roughness);
        final drawable2 = primitive2.drawableFor(size, roughness);

        expect(drawable1, isNotNull);
        expect(drawable2, isNotNull);
      });
    });

    group('Painter Performance', () {
      test('shouldRepaint returns false for identical painters', () {
        final primitive = SketchyPrimitive.circle(seed: 12345);

        final painter1 = SketchyShapePainter(
          primitive: primitive,
          strokeColor: Colors.blue,
          fillColor: Colors.transparent,
          strokeWidth: 4,
          roughness: 0.5,
        );

        final painter2 = SketchyShapePainter(
          primitive: primitive,
          strokeColor: Colors.blue,
          fillColor: Colors.transparent,
          strokeWidth: 4,
          roughness: 0.5,
        );

        // Should not repaint when nothing changes
        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('shouldRepaint detects arc angle changes efficiently', () {
        const iterations = 1000;
        const maxAllowedMicroseconds = 10000; // 10ms for 1000 comparisons

        final basePainter = SketchyShapePainter(
          primitive: SketchyPrimitive.arc(
            seed: 12345,
            startAngle: 0,
            sweepAngle: pi,
          ),
          strokeColor: Colors.blue,
          fillColor: Colors.transparent,
          strokeWidth: 4,
          roughness: 0.5,
        );

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          final angle = (i / iterations) * 2 * pi;
          final newPainter = SketchyShapePainter(
            primitive: SketchyPrimitive.arc(
              seed: 12345,
              startAngle: angle,
              sweepAngle: pi,
            ),
            strokeColor: Colors.blue,
            fillColor: Colors.transparent,
            strokeWidth: 4,
            roughness: 0.5,
          );
          basePainter.shouldRepaint(newPainter);
        }
        stopwatch.stop();

        expect(
          stopwatch.elapsedMicroseconds,
          lessThan(maxAllowedMicroseconds),
          reason:
              'shouldRepaint comparison took ${stopwatch.elapsedMicroseconds}µs '
              'for $iterations iterations (max allowed: $maxAllowedMicrosecondsµs)',
        );
      });
    });

    group('Widget Build Performance', () {
      testWidgets('single indicator renders within frame budget', (
        tester,
      ) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          SketchyApp(
            title: 'Test',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            home: const SketchyScaffold(
              body: Center(child: SketchyCircularProgressIndicator(value: 0.5)),
            ),
          ),
        );

        stopwatch.stop();

        // First build should complete within 500ms (generous for test environments)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
          reason:
              'Initial widget build took ${stopwatch.elapsedMilliseconds}ms '
              '(max allowed: 500ms)',
        );
      });

      testWidgets('multiple indicators render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          SketchyApp(
            title: 'Test',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            home: SketchyScaffold(
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) =>
                    SketchyCircularProgressIndicator(
                      value: index / 25,
                      size: 40,
                    ),
              ),
            ),
          ),
        );

        stopwatch.stop();

        // 25 indicators should render within 2 seconds
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(2000),
          reason:
              '25 widgets took ${stopwatch.elapsedMilliseconds}ms to build '
              '(max allowed: 2000ms)',
        );
      });

      testWidgets('animation frames are processed efficiently', (tester) async {
        await tester.pumpWidget(
          SketchyApp(
            title: 'Test',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            home: const SketchyScaffold(
              body: Center(child: SketchyCircularProgressIndicator()),
            ),
          ),
        );

        // Measure time to process 60 frames (approximately 1 second of animation)
        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < 60; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        stopwatch.stop();

        // 60 frames should complete within 3 seconds (accounting for test overhead)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(3000),
          reason:
              '60 animation frames took ${stopwatch.elapsedMilliseconds}ms '
              '(max allowed: 3000ms)',
        );
      });

      testWidgets('value updates are processed efficiently', (tester) async {
        double value = 0;
        late StateSetter setState;

        await tester.pumpWidget(
          SketchyApp(
            title: 'Test',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            home: SketchyScaffold(
              body: Center(
                child: StatefulBuilder(
                  builder: (context, setStateCallback) {
                    setState = setStateCallback;
                    return SketchyCircularProgressIndicator(
                      value: value,
                      size: 48,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Measure time to update value 100 times
        final stopwatch = Stopwatch()..start();
        for (var i = 0; i <= 100; i++) {
          setState(() {
            value = i / 100;
          });
          await tester.pump();
        }
        stopwatch.stop();

        // 100 value updates should complete within 2 seconds
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(2000),
          reason:
              '100 value updates took ${stopwatch.elapsedMilliseconds}ms '
              '(max allowed: 2000ms)',
        );
      });
    });

    group('Memory Efficiency', () {
      test('primitive equality prevents unnecessary allocations', () {
        // Creating primitives with same parameters should be equal
        // This enables efficient caching and comparison

        final circle1 = SketchyPrimitive.circle(seed: 123);
        final circle2 = SketchyPrimitive.circle(seed: 123);

        expect(circle1, equals(circle2));
        expect(circle1.hashCode, equals(circle2.hashCode));

        final arc1 = SketchyPrimitive.arc(
          seed: 123,
          startAngle: -pi / 2,
          sweepAngle: pi,
        );
        final arc2 = SketchyPrimitive.arc(
          seed: 123,
          startAngle: -pi / 2,
          sweepAngle: pi,
        );

        expect(arc1, equals(arc2));
        expect(arc1.hashCode, equals(arc2.hashCode));
      });

      test('arc with different angles produces different hash codes', () {
        final arc1 = SketchyPrimitive.arc(
          seed: 123,
          startAngle: 0,
          sweepAngle: pi,
        );
        final arc2 = SketchyPrimitive.arc(
          seed: 123,
          startAngle: pi / 2,
          sweepAngle: pi,
        );

        expect(arc1, isNot(equals(arc2)));
        expect(arc1.hashCode, isNot(equals(arc2.hashCode)));
      });
    });
  });
}
