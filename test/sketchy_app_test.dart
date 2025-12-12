import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  group('SketchyApp', () {
    testWidgets('creates app with default constructor', (tester) async {
      await tester.pumpWidget(
        SketchyApp(title: 'Test App', home: const Text('Home')),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('applies custom theme', (tester) async {
      final customTheme = SketchyThemeData.fromTheme(SketchyThemes.monochrome);

      await tester.pumpWidget(
        SketchyApp(
          title: 'Test App',
          theme: customTheme,
          home: SketchyTheme.consumer(
            builder: (context, theme) {
              expect(theme.paperColor, customTheme.paperColor);
              expect(theme.inkColor, customTheme.inkColor);
              return const Text('Themed');
            },
          ),
        ),
      );

      expect(find.text('Themed'), findsOneWidget);
    });

    testWidgets('supports static routes', (tester) async {
      await tester.pumpWidget(
        SketchyApp(
          title: 'Test App',
          home: const Text('Home'),
          routes: {'/second': (context) => const Text('Second Page')},
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      // Navigate to second page
      final context = tester.element(find.text('Home'));
      unawaited(Navigator.of(context).pushNamed('/second'));
      await tester.pumpAndSettle();

      expect(find.text('Second Page'), findsOneWidget);
    });

    testWidgets('supports onGenerateRoute', (tester) async {
      await tester.pumpWidget(
        SketchyApp(
          title: 'Test App',
          home: const Text('Home'),
          onGenerateRoute: (settings) {
            if (settings.name == '/dynamic') {
              return SketchyPageRoute(
                builder: (context) => const Text('Dynamic Route'),
                settings: settings,
              );
            }
            return null;
          },
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      final context = tester.element(find.text('Home'));
      unawaited(Navigator.of(context).pushNamed('/dynamic'));
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Route'), findsOneWidget);
    });

    testWidgets('theme mode system uses platform brightness', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: SketchyApp(
            title: 'Test App',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            darkTheme: SketchyThemeData.fromTheme(SketchyThemes.violet),
            themeMode: SketchyThemeMode.system,
            home: SketchyTheme.consumer(
              builder: (context, theme) {
                // Should use violet (dark theme) because platform is dark
                final violetTheme = SketchyThemeData.fromTheme(
                  SketchyThemes.violet,
                );
                expect(theme.primaryColor, violetTheme.primaryColor);
                return const Text('Dark Mode');
              },
            ),
          ),
        ),
      );

      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('theme mode light always uses light theme', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: SketchyApp(
            title: 'Test App',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            darkTheme: SketchyThemeData.fromTheme(SketchyThemes.violet),
            themeMode: SketchyThemeMode.light,
            home: SketchyTheme.consumer(
              builder: (context, theme) {
                // Should use monochrome despite dark platform
                final monochromeTheme = SketchyThemeData.fromTheme(
                  SketchyThemes.monochrome,
                );
                expect(theme.primaryColor, monochromeTheme.primaryColor);
                return const Text('Light Mode');
              },
            ),
          ),
        ),
      );

      expect(find.text('Light Mode'), findsOneWidget);
    });

    testWidgets('theme mode dark always uses dark theme', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.light),
          child: SketchyApp(
            title: 'Test App',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            darkTheme: SketchyThemeData.fromTheme(SketchyThemes.violet),
            themeMode: SketchyThemeMode.dark,
            home: SketchyTheme.consumer(
              builder: (context, theme) {
                // Should use violet despite light platform
                final violetTheme = SketchyThemeData.fromTheme(
                  SketchyThemes.violet,
                );
                expect(theme.primaryColor, violetTheme.primaryColor);
                return const Text('Dark Mode');
              },
            ),
          ),
        ),
      );

      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('derives dark theme when not provided', (tester) async {
      final lightTheme = SketchyThemeData.fromTheme(SketchyThemes.monochrome);

      await tester.pumpWidget(
        SketchyApp(
          title: 'Test App',
          theme: lightTheme,
          themeMode: SketchyThemeMode.dark,
          home: SketchyTheme.consumer(
            builder: (context, theme) {
              // Should derive dark theme by swapping colors
              expect(theme.paperColor, lightTheme.inkColor);
              expect(theme.inkColor, lightTheme.paperColor);
              expect(theme.primaryColor, lightTheme.secondaryColor);
              expect(theme.secondaryColor, lightTheme.primaryColor);
              return const Text('Derived Dark');
            },
          ),
        ),
      );

      expect(find.text('Derived Dark'), findsOneWidget);
    });

    testWidgets('applies custom builder', (tester) async {
      var builderCalled = false;

      await tester.pumpWidget(
        SketchyApp(
          title: 'Test App',
          home: const Text('Home'),
          builder: (context, child) {
            builderCalled = true;
            return Container(child: child);
          },
        ),
      );

      expect(builderCalled, isTrue);
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('SketchyApp.router', () {
    testWidgets('creates app with router constructor', (tester) async {
      final routerConfig = RouterConfig(
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(uri: Uri(path: '/')),
        ),
        routeInformationParser: _TestRouteInformationParser(),
        routerDelegate: _TestRouterDelegate(),
      );

      await tester.pumpWidget(
        SketchyApp.router(routerConfig: routerConfig, title: 'Router App'),
      );

      await tester.pumpAndSettle();
      expect(find.text('Router Home'), findsOneWidget);
    });

    testWidgets('applies custom theme with router', (tester) async {
      final customTheme = SketchyThemeData.fromTheme(SketchyThemes.monochrome);
      final routerConfig = RouterConfig(
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(uri: Uri(path: '/')),
        ),
        routeInformationParser: _TestRouteInformationParser(),
        routerDelegate: _TestRouterDelegate(),
      );

      await tester.pumpWidget(
        SketchyApp.router(
          routerConfig: routerConfig,
          title: 'Router App',
          theme: customTheme,
        ),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.text('Router Home'));
      final theme = SketchyTheme.of(context);

      expect(theme.paperColor, customTheme.paperColor);
      expect(theme.inkColor, customTheme.inkColor);
    });

    testWidgets('supports theme modes with router', (tester) async {
      final routerConfig = RouterConfig(
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(uri: Uri(path: '/')),
        ),
        routeInformationParser: _TestRouteInformationParser(),
        routerDelegate: _TestRouterDelegate(),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: SketchyApp.router(
            routerConfig: routerConfig,
            title: 'Router App',
            theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
            darkTheme: SketchyThemeData.fromTheme(SketchyThemes.violet),
            themeMode: SketchyThemeMode.system,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.text('Router Home'));
      final theme = SketchyTheme.of(context);

      // Should use dark theme
      final violetTheme = SketchyThemeData.fromTheme(SketchyThemes.violet);
      expect(theme.primaryColor, violetTheme.primaryColor);
    });

    testWidgets('applies custom builder with router', (tester) async {
      var builderCalled = false;
      final routerConfig = RouterConfig(
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(uri: Uri(path: '/')),
        ),
        routeInformationParser: _TestRouteInformationParser(),
        routerDelegate: _TestRouterDelegate(),
      );

      await tester.pumpWidget(
        SketchyApp.router(
          routerConfig: routerConfig,
          title: 'Router App',
          builder: (context, child) {
            builderCalled = true;
            return Container(child: child);
          },
        ),
      );

      await tester.pumpAndSettle();
      expect(builderCalled, isTrue);
      expect(find.text('Router Home'), findsOneWidget);
    });
  });
}

// Test router implementation for testing purposes
class _TestRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) async => routeInformation.uri.path;

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(configuration));
}

class _TestRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _currentPath = '/';

  @override
  String get currentConfiguration => _currentPath;

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: const [_TestPage(child: Text('Router Home'))],
    onDidRemovePage: (page) {},
    // onPopPage: (page, route) {
    //   if (!route.didPop(null)) {
    //     return false;
    //   }
    //   return true;
    // },
  );

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _currentPath = configuration;
  }
}

class _TestPage extends Page<void> {
  const _TestPage({required this.child});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder(
    settings: this,
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );
}
