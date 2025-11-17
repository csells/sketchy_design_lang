import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_page_route.dart';

/// Signature for building Sketchy routes.
typedef SketchyRouteBuilder = WidgetBuilder;

/// Minimal app shell that wires Sketchy theming into a [WidgetsApp].
class SketchyApp extends StatelessWidget {
  /// Creates a Sketchy-powered application.
  const SketchyApp({
    required this.title,
    required this.theme,
    required this.home,
    super.key,
    this.color,
    this.routes,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.initialRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.navigatorObservers,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.builder,
  });

  /// Title exposed to Flutter’s window bindings.
  final String title;

  /// Global theme configuration consumed by Sketchy widgets.
  final SketchyThemeData theme;

  /// Widget shown for the default `/` route.
  final Widget home;

  /// Base color used for the app (defaults to paper).
  final Color? color;

  /// Optional static route table.
  final Map<String, SketchyRouteBuilder>? routes;

  /// Hook for dynamic route generation.
  final RouteFactory? onGenerateRoute;

  /// Hook for generating the initial navigator stack.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// Name of the first route to show.
  final String? initialRoute;

  /// Handler invoked when no route matches.
  final RouteFactory? onUnknownRoute;

  /// Key controlling the navigator bound to this app.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Observers listening to navigator lifecycle events.
  final List<NavigatorObserver>? navigatorObservers;

  /// Locale override used by the app.
  final Locale? locale;

  /// Supported locales surfaced to localization delegates.
  final Iterable<Locale> supportedLocales;

  /// Delegates responsible for loading localized resources.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Callback resolving locale when multiple are available.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Callback resolving locale when a single value is provided.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Whether to show Flutter’s performance overlay.
  final bool showPerformanceOverlay;

  /// Show the semantics debugger overlay.
  final bool showSemanticsDebugger;

  /// Displays the debug banner in debug builds.
  final bool debugShowCheckedModeBanner;

  /// Application-level keyboard shortcuts.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// Application-level actions bound to [shortcuts].
  final Map<Type, Action<Intent>>? actions;

  /// Restoration ID for state restoration APIs.
  final String? restorationScopeId;

  /// Additional builder run after Sketchy themes.
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    navigatorKey: navigatorKey,
    title: title,
    color: color ?? theme.colors.paper,
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    localeListResolutionCallback: localeListResolutionCallback,
    localeResolutionCallback: localeResolutionCallback,
    showPerformanceOverlay: showPerformanceOverlay,
    showSemanticsDebugger: showSemanticsDebugger,
    debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    shortcuts: shortcuts,
    actions: actions,
    restorationScopeId: restorationScopeId,
    builder: (context, child) {
      final content = child ?? const SizedBox.shrink();
      final themed = SketchyTheme(
        data: theme,
        child: DefaultTextStyle(
          style: theme.typography.body.copyWith(color: theme.colors.ink),
          child: content,
        ),
      );
      return builder?.call(context, themed) ?? themed;
    },
    navigatorObservers: navigatorObservers ?? const <NavigatorObserver>[],
    initialRoute: initialRoute,
    onGenerateInitialRoutes: onGenerateInitialRoutes,
    onGenerateRoute: (settings) {
      if (settings.name == Navigator.defaultRouteName) {
        return SketchyPageRoute(builder: (_) => home, settings: settings);
      }

      final mapBuilder = routes?[settings.name];
      if (mapBuilder != null) {
        return SketchyPageRoute(builder: mapBuilder, settings: settings);
      }

      if (onGenerateRoute != null) {
        return onGenerateRoute!(settings);
      }

      return null;
    },
    onUnknownRoute: onUnknownRoute,
  );
}
