// Test just the header from ChatMainArea
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'package:example_chat/src/models/mock_data.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Header Only Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = MockData.channels.first;

    return SketchyTheme.consumer(
      builder: (context, theme) => ColoredBox(
        color: theme.paperColor,
        child: Column(
          children: [
            // Exact header from ChatMainArea
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SketchySymbol(
                    symbol: SketchySymbols.hash,
                    size: 20,
                    color: theme.inkColor,
                  ),
                  const SizedBox(width: 4),
                  SketchyText(
                    channel.name,
                    style: theme.typography.title.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.inkColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SketchyText(
                      channel.description ?? '',
                      style: theme.typography.body.copyWith(
                        color: theme.inkColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  SketchySymbol(
                    symbol: SketchySymbols.people,
                    size: 18,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  SketchyText(
                    '5',
                    style: theme.typography.body.copyWith(
                      color: theme.inkColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SketchyDivider(),
            const Expanded(
              child: Center(
                child: Text('Content area'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
