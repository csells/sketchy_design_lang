// Test SketchyChatInput only
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Input Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => ColoredBox(
          color: theme.paperColor,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SketchyChatInput(
                  hintText: 'Message #test',
                  onSubmitted: (text) => print('Sent: $text'),
                ),
              ),
            ],
          ),
        ),
      );
}
