# CLAUDE.md - Sketchy Design Language

## Project Overview
Sketchy is a hand-drawn, xkcd-inspired design language for Flutter (mobile,
desktop, web). It provides a complete theming system and widget catalog that
intentionally avoids Material/Cupertino. All controls are drawn with
`rough_flutter` using seeded primitives for deterministic rendering.

## Build & Test Commands
```bash
flutter analyze        # Run linter
flutter test           # Run all tests
flutter run            # Run example app (from /example directory)
```

## Critical Architecture Rules

### Material Dependency Policy
Sketchy intentionally avoids Material to provide a pure hand-drawn aesthetic.
**Minimize Material usage** with these specific exceptions:

| Exception | Reason |
|-----------|--------|
| `SketchyTextField` uses Material `TextField` | Flutter's widgets-only layer has no text editing widget with selection handles, cursor blinking, clipboard access, or IME support. Material TextField is required for production-quality text input. |
| `SketchyApp` imports `DefaultMaterialLocalizations` | Required for text selection semantics (copy/paste labels, etc.) |
| `SketchyApp` imports `ScaffoldMessenger` | Required for snack bar display infrastructure |
| `SketchyTabBar` aliases Material tab types | `TabController` requires Material's `TickerProviderStateMixin` integration; aliased as `SketchyTabController`, `SketchyDefaultTabController`, `SketchyTab` |

**Rules:**
- **NO Material imports** in any other Sketchy widgets
- If Material types must be used internally, create Sketchy-named typedefs
  (e.g., `typedef SketchyTabController = material.TabController`)
- **Never expose Material types through public widget APIs**
- Create Sketchy equivalents for Material enums/types (e.g.,
  `SketchyControlAffinity` instead of `ListTileControlAffinity`,
  `SketchyFabLocation` instead of `FloatingActionButtonLocation`)

### Sketchy Widget Guidelines

- **Cache Primitives in State** – all Sketchy widgets that create
  `SketchyPrimitive` instances must be `StatefulWidget`s and cache their
  primitives in state (e.g., `late final` in `initState()` or lazy caching when
  theme values are needed). Never create primitives in `build()` as this causes
  unbounded memory growth from new random seeds on every rebuild.

Pattern for fixed primitives:
```dart
class SketchyWidget extends StatefulWidget {
  // ...
}

class _SketchyWidgetState extends State<SketchyWidget> {
  late final SketchyPrimitive _primitive;

  @override
  void initState() {
    super.initState();
    _primitive = SketchyPrimitive.rectangle(fill: SketchyFill.solid);
  }

  @override
  Widget build(BuildContext context) {
    // Use _primitive, NOT SketchyPrimitive.rectangle() inline
  }
}
```

Pattern for conditional/lazy primitives:
```dart
SketchyPrimitive? _cachedPrimitive;
SketchyPrimitive _getPrimitive() =>
    _cachedPrimitive ??= SketchyPrimitive.rectangle();
```

### Core Building Blocks
- `SketchyPrimitive` - Shape configuration with random seed for deterministic
  rendering
- `SketchySurface` - Paints a primitive behind child widgets
- `SketchyFrame` - Convenience wrapper for rectangles/circles/pills with padding
- `SketchyGenerator` - Generates rough drawables from primitives (stateless)

## Architecture Principles

- **TDD (Test-Driven Development)** – write the tests first; the implementation
  code isn't done until the tests pass.
- **DRY (Don't Repeat Yourself)** – eliminate duplicated logic by extracting
  shared utilities and modules.
- **Separation of Concerns** – each module should handle one distinct
  responsibility.
- **Single Responsibility Principle (SRP)** – every class/module/function/file
  should have exactly one reason to change.
- **Clear Abstractions & Contracts** – expose intent through small, stable
  interfaces and hide implementation details.
- **Low Coupling, High Cohesion** – keep modules self-contained, minimize
  cross-dependencies.
- **Scalability & Statelessness** – design components to scale horizontally and
  prefer stateless services when possible.
- **Observability & Testability** – build in logging, metrics, tracing, and
  ensure components can be unit/integration tested.
- **KISS (Keep It Simple, Sir)** – keep solutions as simple as possible.
- **YAGNI (You're Not Gonna Need It)** – avoid speculative complexity or
  over-engineering.
- **Don't Swallow Errors** by catching exceptions, silently filling in required
  but missing values or adding timeouts when something hangs unexpectedly. All
  of those are exceptions that should be thrown so that the errors can be seen,
  root causes can be found and fixes can be applied.
- **No Placeholder Code** – we're building production code here, not toys.
- **No Comments for Removed Functionality** – the source is not the place to
  keep history of what's changed; it's the place to implement the current
  requirements only.
- **Layered Architecture** – organize code into clear tiers where each layer
  depends only on the one(s) below it, keeping logic cleanly separated.

## Code Style

### Theme Access
Prefer the consumer pattern:
```dart
return SketchyTheme.consumer(
  builder: (context, theme) => SketchyText(
    'Hello',
    style: TextStyle(color: theme.inkColor),
  ),
);
```

### Widget Exports
New widgets must be exported through `lib/src/widgets/widgets.dart`

### Error Handling
- **Never use try-catch** in sample apps or tests
- **Never swallow exceptions** – they help find problems
- Find and fix root causes rather than papering over errors

### Formatting
- Lines ≤80 characters

## Project Structure
```
lib/
  src/
    app/          # SketchyApp, SketchyPageRoute
    primitives/   # SketchyPrimitive, SketchyGenerator, SketchyShapePainter
    theme/        # SketchyTheme, SketchyThemeData, SketchyTypography, colors
    widgets/      # All Sketchy widgets (exported via widgets.dart)
example/          # Example apps
specs/            # Design specifications and best practices
test/             # Tests
```

## Key Dependencies
- `rough_flutter: ^0.1.2` – Rough/sketchy rendering engine
- Comic Shanns font bundled at `lib/fonts/`
