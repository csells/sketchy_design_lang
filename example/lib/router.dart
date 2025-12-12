import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

// Custom back arrow widget to avoid Material dependency
class _BackArrow extends StatelessWidget {
  const _BackArrow();

  @override
  Widget build(BuildContext context) =>
      const Text('←', style: TextStyle(fontSize: 24));
}

/// Example demonstrating SketchyApp.router with go_router.
///
/// This example shows how to use the declarative routing API with SketchyApp,
/// enabling modern navigation patterns including:
/// - Deep linking
/// - Named routes with parameters

void main() => runApp(const RouterExampleApp());

class RouterExampleApp extends StatelessWidget {
  const RouterExampleApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp.router(
    title: 'Sketchy Router Example',
    theme: SketchyThemeData.fromTheme(SketchyThemes.monochrome),
    darkTheme: SketchyThemeData.fromTheme(SketchyThemes.dusty),
    themeMode: SketchyThemeMode.light,
    routerConfig: _router,
  );
}

// Define the router configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'unknown';
            return DetailsPage(id: id);
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => SketchyScaffold(
    appBar: const SketchyAppBar(title: Text('Router Example')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SketchyText(
            'Welcome to Sketchy Router!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          const SketchyText(
            'Navigate using declarative routing:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _NavigationButton(
            label: 'View Details (Item 1)',
            onPressed: () => context.go('/details/1'),
          ),
          const SizedBox(height: 16),
          _NavigationButton(
            label: 'View Details (Item 42)',
            onPressed: () => context.go('/details/42'),
          ),
          const SizedBox(height: 16),
          _NavigationButton(
            label: 'Profile',
            onPressed: () => context.go('/profile'),
          ),
          const SizedBox(height: 16),
          _NavigationButton(
            label: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
    ),
  );
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) => SketchyScaffold(
    appBar: SketchyAppBar(
      title: Text('Details: $id'),
      leading: SketchyIconButton(
        icon: const _BackArrow(),
        onPressed: () => context.go('/'),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SketchyText(
            'Item ID: $id',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const SketchyText(
            'This demonstrates routing with path parameters.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          _NavigationButton(
            label: 'Back to Home',
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => SketchyScaffold(
    appBar: SketchyAppBar(
      title: const Text('Profile'),
      leading: SketchyIconButton(
        icon: const _BackArrow(),
        onPressed: () => context.go('/'),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SketchyText(
            'User Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const SketchyText(
            'This is a simple profile page.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          _NavigationButton(
            label: 'Back to Home',
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => SketchyScaffold(
    appBar: SketchyAppBar(
      title: const Text('Settings'),
      leading: SketchyIconButton(
        icon: const _BackArrow(),
        onPressed: () => context.go('/'),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SketchyText(
            'App Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const SketchyText(
            'Configure your app preferences here.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          _NavigationButton(
            label: 'Back to Home',
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    ),
  );
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SketchyButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(label),
    ),
  );
}
