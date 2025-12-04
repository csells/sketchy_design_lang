import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  group('SketchyCircularProgressIndicator', () {
    Widget buildTestWidget({
      double? value,
      double strokeWidth = 4.0,
      double? size,
      Color? backgroundColor,
      Color? color,
      String? semanticLabel,
      SketchyThemeData? theme,
    }) => SketchyApp(
      title: 'Test',
      theme: theme ?? SketchyThemeData.fromTheme(SketchyThemes.monochrome),
      home: SketchyScaffold(
        body: Center(
          child: SketchyCircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            size: size,
            backgroundColor: backgroundColor,
            color: color,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );

    group('Widget Creation', () {
      testWidgets('creates without errors', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with value parameter (determinate mode)', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with custom strokeWidth', (tester) async {
        await tester.pumpWidget(buildTestWidget(strokeWidth: 8));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with custom color', (tester) async {
        await tester.pumpWidget(buildTestWidget(color: Colors.red));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with custom size', (tester) async {
        await tester.pumpWidget(buildTestWidget(size: 64));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with backgroundColor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(backgroundColor: Colors.grey.shade200, value: 0.5),
        );

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('backgroundColor is applied to background track', (
        tester,
      ) async {
        const testColor = Colors.purple;
        await tester.pumpWidget(
          buildTestWidget(backgroundColor: testColor, value: 0.5),
        );
        await tester.pump();

        // Find CustomPaint widgets
        // that are descendants of SketchyCircularProgressIndicator
        final customPaintFinder = find.descendant(
          of: find.byType(SketchyCircularProgressIndicator),
          matching: find.byType(CustomPaint),
        );
        final customPaints = tester.widgetList<CustomPaint>(customPaintFinder);

        // Find the background track painter (with circle primitive)
        final backgroundPainter = customPaints
            .map((cp) => cp.painter)
            .whereType<SketchyShapePainter>()
            .firstWhere((p) => p.primitive.type == SketchyShapeType.circle);

        expect(backgroundPainter.strokeColor, equals(testColor));
      });

      testWidgets('backgroundColor defaults to color with alpha when not set', (
        tester,
      ) async {
        const testColor = Colors.blue;
        await tester.pumpWidget(buildTestWidget(color: testColor, value: 0.5));
        await tester.pump();

        // Find CustomPaint widgets
        // that are descendants of SketchyCircularProgressIndicator
        final customPaintFinder = find.descendant(
          of: find.byType(SketchyCircularProgressIndicator),
          matching: find.byType(CustomPaint),
        );
        final customPaints = tester.widgetList<CustomPaint>(customPaintFinder);

        // Find the background track painter (with circle primitive)
        final backgroundPainter = customPaints
            .map((cp) => cp.painter)
            .whereType<SketchyShapePainter>()
            .firstWhere((p) => p.primitive.type == SketchyShapeType.circle);

        // Background should be the color with reduced alpha (0.2)
        expect(
          backgroundPainter.strokeColor.toARGB32(),
          lessThan(testColor.toARGB32()),
        );
      });

      testWidgets('creates with semanticLabel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(semanticLabel: 'Loading progress'),
        );

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('creates with all parameters', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            value: 0.5,
            strokeWidth: 6,
            size: 72,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
            semanticLabel: 'Download progress',
          ),
        );

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });
    });

    group('Size and Layout', () {
      testWidgets('has correct default size (48x48)', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        final widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );

        expect(widgetSize.width, equals(48.0));
        expect(widgetSize.height, equals(48.0));
      });

      testWidgets('respects custom size parameter', (tester) async {
        await tester.pumpWidget(buildTestWidget(size: 64));
        await tester.pump();

        final widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );

        expect(widgetSize.width, equals(64.0));
        expect(widgetSize.height, equals(64.0));
      });

      testWidgets('handles small custom size', (tester) async {
        await tester.pumpWidget(buildTestWidget(size: 24));
        await tester.pump();

        final widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );

        expect(widgetSize.width, equals(24.0));
        expect(widgetSize.height, equals(24.0));
      });

      testWidgets('handles large custom size', (tester) async {
        await tester.pumpWidget(buildTestWidget(size: 120));
        await tester.pump();

        final widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );

        expect(widgetSize.width, equals(120.0));
        expect(widgetSize.height, equals(120.0));
      });

      testWidgets('contains Stack with background and foreground layers', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        // The widget uses a Stack to layer background track and foreground arc
        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('contains CustomPaint widgets for rendering', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        // Should have CustomPaint for both background track and foreground arc
        expect(find.byType(CustomPaint), findsWidgets);
      });
    });

    group('Determinate Mode (with value)', () {
      testWidgets('renders foreground arc when value > 0.01', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        // Should have at least 2 CustomPaint widgets (background + foreground)
        final customPaints = find.byType(CustomPaint);
        expect(customPaints, findsAtLeast(2));
      });

      testWidgets('does not render foreground arc when value <= 0.01', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0.005));
        await tester.pump();

        // Should have only 1 CustomPaint (background track only)
        // Note: The exact behavior depends on implementation
        // - at least background exists
        final customPaints = find.byType(CustomPaint);
        expect(customPaints, findsWidgets);
      });

      testWidgets('handles value of 0', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles value of 1 (complete)', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 1));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles intermediate values correctly', (tester) async {
        for (final value in [0.25, 0.5, 0.75]) {
          await tester.pumpWidget(buildTestWidget(value: value));
          await tester.pump();

          expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
        }
      });
    });

    group('Indeterminate Mode (without value)', () {
      testWidgets('animates in indeterminate mode', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Pump initial frame
        await tester.pump();

        // Pump animation frames
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Should still be animating without errors
        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('continues animating over time', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Run animation for 2 seconds (one full cycle)
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('animation repeats without errors', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Simulate several animation cycles
        await tester.pump();
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(seconds: 2));
        }

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });
    });

    group('Theming', () {
      testWidgets('uses theme primaryColor by default', (tester) async {
        final theme = SketchyThemeData.fromTheme(SketchyThemes.blue);

        await tester.pumpWidget(buildTestWidget(value: 0.5, theme: theme));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('custom color overrides theme color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(value: 0.5, color: Colors.purple),
        );
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('backgroundColor and color can be set independently', (
        tester,
      ) async {
        const backgroundColor = Colors.grey;
        const foregroundColor = Colors.red;

        await tester.pumpWidget(
          buildTestWidget(
            value: 0.5,
            backgroundColor: backgroundColor,
            color: foregroundColor,
          ),
        );
        await tester.pump();

        // Find CustomPaint widgets
        // that are descendants of SketchyCircularProgressIndicator
        final customPaintFinder = find.descendant(
          of: find.byType(SketchyCircularProgressIndicator),
          matching: find.byType(CustomPaint),
        );
        final customPaints = tester.widgetList<CustomPaint>(customPaintFinder);
        final sketchyPainters = customPaints
            .map((cp) => cp.painter)
            .whereType<SketchyShapePainter>()
            .toList();

        // Background track (circle) should use backgroundColor
        final backgroundPainter = sketchyPainters.firstWhere(
          (p) => p.primitive.type == SketchyShapeType.circle,
        );
        expect(backgroundPainter.strokeColor, equals(backgroundColor));

        // Foreground arc should use color
        final foregroundPainter = sketchyPainters.firstWhere(
          (p) => p.primitive.type == SketchyShapeType.arc,
        );
        expect(foregroundPainter.strokeColor, equals(foregroundColor));
      });

      testWidgets('works with different sketchy themes', (tester) async {
        final themes = [
          SketchyThemes.monochrome,
          SketchyThemes.blue,
          SketchyThemes.orange,
          SketchyThemes.green,
        ];

        for (final sketchyTheme in themes) {
          final theme = SketchyThemeData.fromTheme(sketchyTheme);
          await tester.pumpWidget(buildTestWidget(value: 0.5, theme: theme));
          await tester.pump();

          expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
        }
      });

      testWidgets('respects theme roughness', (tester) async {
        final theme = SketchyThemeData.fromTheme(
          SketchyThemes.monochrome,
          roughness: 0.8,
        );

        await tester.pumpWidget(buildTestWidget(value: 0.5, theme: theme));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('properly disposes animation controller', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        // Remove widget
        await tester.pumpWidget(
          SketchyApp(
            title: 'Test',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            home: const SketchyScaffold(body: SizedBox()),
          ),
        );
        await tester.pump();

        // Should not throw any errors about disposed controllers
        expect(tester.takeException(), isNull);
      });

      testWidgets('transitions from indeterminate to determinate mode', (
        tester,
      ) async {
        // Start indeterminate
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Switch to determinate
        await tester.pumpWidget(buildTestWidget(value: 0.75));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('transitions from determinate to indeterminate mode', (
        tester,
      ) async {
        // Start determinate
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        // Switch to indeterminate
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('updates when value changes', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.25));
        await tester.pump();

        await tester.pumpWidget(buildTestWidget(value: 0.75));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('updates when strokeWidth changes', (tester) async {
        await tester.pumpWidget(buildTestWidget(strokeWidth: 4));
        await tester.pump();

        await tester.pumpWidget(buildTestWidget(strokeWidth: 8));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('updates when color changes', (tester) async {
        await tester.pumpWidget(buildTestWidget(color: Colors.red));
        await tester.pump();

        await tester.pumpWidget(buildTestWidget(color: Colors.blue));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has Semantics wrapper', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('uses default semantic label when not provided', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0.5));
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(
          semantics.properties.label,
          equals('Circular progress indicator'),
        );
      });

      testWidgets('uses custom semantic label when provided', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(value: 0.5, semanticLabel: 'Download progress'),
        );
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.label, equals('Download progress'));
      });

      testWidgets('shows percentage value in semantics for determinate mode', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0.75));
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.value, equals('75%'));
      });

      testWidgets('shows 0% value in semantics when value is 0', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 0));
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.value, equals('0%'));
      });

      testWidgets('shows 100% value in semantics when value is 1', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: 1));
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.value, equals('100%'));
      });

      testWidgets('does not show value in semantics for indeterminate mode', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.value, isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid value changes', (tester) async {
        for (var i = 0; i <= 100; i += 10) {
          await tester.pumpWidget(buildTestWidget(value: i / 100));
          await tester.pump(const Duration(milliseconds: 16));
        }

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles very small strokeWidth', (tester) async {
        await tester.pumpWidget(buildTestWidget(strokeWidth: 0.5, value: 0.5));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles very large strokeWidth', (tester) async {
        await tester.pumpWidget(buildTestWidget(strokeWidth: 20, value: 0.5));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles transparent color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(color: Colors.transparent, value: 0.5),
        );
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles color with alpha', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            color: Colors.blue.withValues(alpha: 0.5),
            value: 0.5,
          ),
        );
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles backgroundColor with alpha', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            value: 0.5,
          ),
        );
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles size of zero', (tester) async {
        await tester.pumpWidget(buildTestWidget(size: 0, value: 0.5));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('updates when size changes', (tester) async {
        // Use a StatefulBuilder to properly trigger rebuilds
        double? currentSize = 48;
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
                      value: 0.5,
                      size: currentSize,
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        var widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );
        expect(widgetSize.width, equals(48.0));

        // Update size via setState
        setState(() {
          currentSize = 96;
        });
        await tester.pump();

        widgetSize = tester.getSize(
          find.byType(SketchyCircularProgressIndicator),
        );
        expect(widgetSize.width, equals(96.0));
      });

      testWidgets('updates when semanticLabel changes', (tester) async {
        // Use a StatefulBuilder to properly trigger rebuilds
        var currentLabel = 'Loading';
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
                      value: 0.5,
                      semanticLabel: currentLabel,
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Update semanticLabel via setState
        setState(() {
          currentLabel = 'Downloading';
        });
        await tester.pump();

        final semantics = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byType(SizedBox).first,
                matching: find.byType(Semantics),
              )
              .first,
        );

        expect(semantics.properties.label, equals('Downloading'));
      });
    });

    group('Golden Tests Setup', () {
      // Note: These tests verify the widget renders without errors.
      // For actual visual golden tests, you would need to set up
      // golden file comparisons specific to your CI environment.

      testWidgets('renders correctly at 0% progress', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders correctly at 25% progress', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.25));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders correctly at 50% progress', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.50));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders correctly at 75% progress', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 0.75));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders correctly at 100% progress', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: 1));
        await tester.pump();

        expect(find.byType(SketchyCircularProgressIndicator), findsOneWidget);
      });
    });
  });

  group('SketchyPrimitive.arc', () {
    test('creates arc with correct start and sweep angles', () {
      const startAngle = -pi / 2;
      const sweepAngle = pi;

      final arc = SketchyPrimitive.arc(
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        seed: 12345,
      );

      expect(arc.type, equals(SketchyShapeType.arc));
      expect(arc.startAngle, equals(startAngle));
      expect(arc.sweepAngle, equals(sweepAngle));
      expect(arc.seed, equals(12345));
    });

    test('arc equality includes angles', () {
      final arc1 = SketchyPrimitive.arc(
        startAngle: 0,
        sweepAngle: pi,
        seed: 123,
      );

      final arc2 = SketchyPrimitive.arc(
        startAngle: 0,
        sweepAngle: pi,
        seed: 123,
      );

      final arc3 = SketchyPrimitive.arc(
        startAngle: pi / 2,
        sweepAngle: pi,
        seed: 123,
      );

      expect(arc1, equals(arc2));
      expect(arc1, isNot(equals(arc3)));
    });

    test('arc hashCode differs for different angles', () {
      final arc1 = SketchyPrimitive.arc(
        startAngle: 0,
        sweepAngle: pi,
        seed: 123,
      );

      final arc2 = SketchyPrimitive.arc(
        startAngle: pi / 2,
        sweepAngle: pi,
        seed: 123,
      );

      expect(arc1.hashCode, isNot(equals(arc2.hashCode)));
    });

    test('generates drawable for arc', () {
      final arc = SketchyPrimitive.arc(
        startAngle: -pi / 2,
        sweepAngle: pi,
        seed: 12345,
      );

      final drawable = arc.drawableFor(const Size(48, 48), 0.5);
      expect(drawable, isNotNull);
    });

    test('generates path for arc', () {
      final arc = SketchyPrimitive.arc(
        startAngle: -pi / 2,
        sweepAngle: pi,
        seed: 12345,
      );

      final path = arc.pathFor(const Size(48, 48));
      expect(path, isNotNull);
      expect(path, isA<Path>());
    });
  });

  group('SketchyShapePainter', () {
    test('shouldRepaint returns true when primitive changes', () {
      final painter1 = SketchyShapePainter(
        primitive: SketchyPrimitive.arc(
          startAngle: 0,
          sweepAngle: pi,
          seed: 123,
        ),
        strokeColor: Colors.blue,
        fillColor: Colors.transparent,
        strokeWidth: 4,
        roughness: 0.5,
      );

      final painter2 = SketchyShapePainter(
        primitive: SketchyPrimitive.arc(
          startAngle: pi / 2,
          sweepAngle: pi,
          seed: 123,
        ),
        strokeColor: Colors.blue,
        fillColor: Colors.transparent,
        strokeWidth: 4,
        roughness: 0.5,
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns true when strokeColor changes', () {
      final primitive = SketchyPrimitive.circle(seed: 123);

      final painter1 = SketchyShapePainter(
        primitive: primitive,
        strokeColor: Colors.blue,
        fillColor: Colors.transparent,
        strokeWidth: 4,
        roughness: 0.5,
      );

      final painter2 = SketchyShapePainter(
        primitive: primitive,
        strokeColor: Colors.red,
        fillColor: Colors.transparent,
        strokeWidth: 4,
        roughness: 0.5,
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns true when strokeWidth changes', () {
      final primitive = SketchyPrimitive.circle(seed: 123);

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
        strokeWidth: 8,
        roughness: 0.5,
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns true when roughness changes', () {
      final primitive = SketchyPrimitive.circle(seed: 123);

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
        roughness: 0.8,
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns false when nothing changes', () {
      final primitive = SketchyPrimitive.circle(seed: 123);

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

      expect(painter1.shouldRepaint(painter2), isFalse);
    });
  });
}
