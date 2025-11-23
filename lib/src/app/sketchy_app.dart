import 'package:flutter/material.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_page_route.dart';

/// Controls which Sketchy theme variant should be used.
enum SketchyThemeMode {
  /// Follows the current platform brightness.
  system,

  /// Forces Sketchy to use the provided light theme.
  light,

  /// Forces Sketchy to use the provided dark theme when available.
  dark,
}

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
    this.darkTheme,
    this.themeMode = SketchyThemeMode.system,
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

  /// Global light theme configuration consumed by Sketchy widgets.
  final SketchyThemeData theme;

  /// Optional dark theme configuration.
  final SketchyThemeData? darkTheme;

  /// Theme mode controlling which theme is active.
  final SketchyThemeMode themeMode;

  /// Widget shown for the default `/` route.
  final Widget home;

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
    color: theme.paperColor,
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: [
      ...?localizationsDelegates,
      DefaultMaterialLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ],
    localeListResolutionCallback: localeListResolutionCallback,
    localeResolutionCallback: localeResolutionCallback,
    showPerformanceOverlay: showPerformanceOverlay,
    showSemanticsDebugger: showSemanticsDebugger,
    debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    shortcuts: shortcuts,
    actions: actions,
    restorationScopeId: restorationScopeId,
    builder: (context, child) {
      final activeTheme = _resolveTheme(context);
      final content = child ?? const SizedBox.shrink();
      final themed = SketchyTheme(
        data: activeTheme,
        child: DefaultTextStyle(
          style: activeTheme.typography.body.copyWith(
            color: activeTheme.inkColor,
          ),
          child: ScaffoldMessenger(child: content),
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

  SketchyThemeData _resolveTheme(BuildContext context) {
    final platformBrightness =
        MediaQuery.maybeOf(context)?.platformBrightness ?? Brightness.light;
    final effectiveMode = switch (themeMode) {
      SketchyThemeMode.system =>
        platformBrightness == Brightness.dark
            ? SketchyThemeMode.dark
            : SketchyThemeMode.light,
      _ => themeMode,
    };
    if (effectiveMode == SketchyThemeMode.dark) {
      return darkTheme ?? _deriveDarkTheme(theme);
    }
    return theme;
  }

  SketchyThemeData _deriveDarkTheme(SketchyThemeData base) => base.copyWith(
    inkColor: base.paperColor,
    paperColor: base.inkColor,
    primaryColor: base.secondaryColor,
    secondaryColor: base.primaryColor,
  );
}
