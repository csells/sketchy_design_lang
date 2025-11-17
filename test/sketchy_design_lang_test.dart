import 'package:flutter_test/flutter_test.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  test('SketchyThemeData exposes ink + paper colors', () {
    final theme = SketchyThemeData.white();
    expect(theme.colors.ink, isNotNull);
    expect(theme.colors.paper, isNotNull);
  });
}
