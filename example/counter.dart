import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _title = 'Sketchy Counter Demo';

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: _title,
    home: const MyHomePage(title: _title),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) => SketchyScaffold(
    appBar: SketchyAppBar(title: Text(widget.title)),
    body: Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const SketchyText('You have pushed the button this many times:'),
          SketchyText('$_counter'),
        ],
      ),
    ),
    floatingActionButton: SketchyButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const SketchySymbol(symbol: SketchySymbols.plus),
    ),
  );
}
