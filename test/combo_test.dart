import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, Scaffold;
import 'package:flutter_test/flutter_test.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  testWidgets('DropdownButton popup sizes to content', (tester) async {
    await tester.pumpWidget(
      SketchyApp(
        title: 'Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
        home: Scaffold(
          body: Center(
            child: DropdownButton<String>(
              value: 'One',
              items: [
                'One',
                'Two',
                'Three',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    // Verify combo is present
    expect(find.byType(DropdownButton<String>), findsOneWidget);

    // Find the combo and tap it
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    // Find the popup content
    final popupFinder = find.text('Two');
    expect(popupFinder, findsOneWidget);

    // Get the size of the popup frame
    // The popup frame is the one wrapping the column of items
    final frameFinder = find
        .ancestor(of: popupFinder, matching: find.byType(SketchyFrame))
        .first;

    final frameSize = tester.getSize(frameFinder);

    // The screen height is 600 by default in tests.
    // The popup should be much smaller than that.
    expect(frameSize.height, lessThan(300));
  });
}
