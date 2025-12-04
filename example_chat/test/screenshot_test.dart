import 'dart:io';
import 'dart:ui' as ui;

import 'package:example_chat/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Capture chat app screenshot', (tester) async {
    // Set a fixed screen size matching the reference screenshot
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    // Build the app
    await tester.pumpWidget(
      const RepaintBoundary(key: Key('screenshot'), child: SketchChatApp()),
    );

    // Wait for animations and rendering to complete
    await tester.pumpAndSettle();

    // Find the RepaintBoundary
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const Key('screenshot')),
    );

    // Capture the image
    final image = await boundary.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    // Save to tmp folder at project root
    final outputPath = '${Directory.current.path}/../tmp/chat_screenshot.png';
    final file = File(outputPath);
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);

    // ignore: avoid_print
    print('Screenshot saved to: $outputPath');

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
