// Test SketchyDrawer specifically
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Drawer Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _drawerController = SketchyDrawerController();

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => SketchyDrawer(
          controller: _drawerController,
          position: SketchyDrawerPosition.end,
          drawerWidth: 300,
          drawer: ColoredBox(
            color: theme.paperColor,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SketchyText(
                            'Test Drawer',
                            style: theme.typography.title,
                          ),
                        ),
                        SketchyIconButton(
                          icon: SketchySymbol(
                            symbol: SketchySymbols.x,
                            size: 16,
                            color: theme.inkColor,
                          ),
                          onPressed: _drawerController.close,
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ),
                  const SketchyDivider(),
                  const Expanded(
                    child: Center(
                      child: SketchyText('Drawer content'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: ColoredBox(
            color: theme.paperColor,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SketchyText('Main Content'),
                  const SizedBox(height: 16),
                  SketchyButton(
                    onPressed: _drawerController.open,
                    child: const SketchyText('Open Drawer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
