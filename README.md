<div align="center">

# Sketchy Design Language for Flutter

Sketchy is a hand-drawn, xkcd-inspired design language for Flutter on mobile,
desktop, and web. It's powered by the wired_elements code, the flutter_rough
package and the Comic Shanns font.

</div>

Sketchy is a complete design language: a theming system, widget catalog, and
example gallery that avoids Material/Cupertino entirely. Every control is drawn
with `rough_flutter`, seeded primitives prevent flicker, and the palette mirrors
the Sketchy Mode color brief.

---

## Table of contents

1. [Getting started](#getting-started)
2. [Core concepts](#core-concepts)
3. [Using Sketchy widgets](#using-sketchy-widgets)
4. [Example gallery & docs](#example-gallery--docs)
5. [Customization recipes](#customization-recipes)
6. [Testing & tooling](#testing--tooling)
7. [Contributing](#contributing)

---

## Getting started

### Install

Add Sketchy directly from git (temporarily) or via whatever source your project
uses:

```yaml
dependencies:
  sketchy_design_lang:
    git:
      url: https://github.com/<your-org>/sketchy_design_lang.git
```

Then fetch packages:

```bash
flutter pub get
```

### Minimal app

```dart
import 'package:flutter/widgets.dart' hide Text;
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() => runApp(const SketchyDemo());

class SketchyDemo extends StatelessWidget {
  const SketchyDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SketchyApp(
      title: 'Sketchy Demo',
      theme: SketchyThemeData.fromTheme(
        SketchyThemes.blue,
        roughness: 0.7,
      ),
      themeMode: SketchyThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: Text('Wireframe Vibes')),
        body: Center(child: OutlinedButton(onPressed: () {}, child: Text('Do the thing'))),
      ),
    );
  }
}
```

The entire widget tree now uses the Sketchy palette, typography, and primitives.
`SketchyApp` works like `MaterialApp`: provide a light `theme`, optionally a
`darkTheme`, and control `themeMode` (`system`, `light`, `dark`). When you omit
`darkTheme`, Sketchy auto-derives one by swapping ink/paper and primary/secondary
colors so dark mode still feels native without extra setup.

---

## Core concepts

### Theme data

`SketchyThemeData` carries:

- **Colors** – ink, paper, primary/secondary, error. Themes include monochrome plus Red → Violet families. Dark mode swaps ink/paper automatically.
- **Roughness** – a 0–1 dial that controls wobble, bowing, hachure spacing, and
  randomness (0 = crisp, 1 = sketchbook chaos).
- **Typography** – defaults to Comic Shanns but you can swap entire families via
  `copyWith`.
- **TextCase** – transforms all text display (labels, headers, tooltips, etc.)
  with four options: `none` (default), `allCaps`, `titleCase`, `allLower`.
  Does NOT affect actual user input. For maximum sketchy vibes, try
  `xkcd` font + `TextCase.allCaps`.
- **Stroke width & border radius** – consistent outlines for every widget.

Access the theme with `SketchyTheme.of(context)` or the consumer pattern
`SketchyTheme.consumer()`. Granular helpers like `SketchyTypography.of(context)`
are also available, though `theme.typography` via the consumer is preferred.

**Traditional pattern:**
```dart
final theme = SketchyTheme.of(context);
return Text('Hello', style: TextStyle(color: theme.inkColor));
```

**Consumer pattern (recommended):**
```dart
return SketchyTheme.consumer(
  builder: (context, theme) => Text(
    'Hello',
    style: TextStyle(color: theme.inkColor),
  ),
);
```

The consumer pattern provides cleaner access to both theme and typography without
multiple lookups, and rebuilds automatically when the theme changes.

### Primitives & surfaces

At the core are `SketchyPrimitive`, `SketchySurface`, and `SketchyFrame`:

- **Primitive** caches draw seeds so shapes remain stable between frames.
- **Surface** paints a primitive behind any child widget.
- **Frame** is a convenience wrapper for rectangles/circles/pills with padding
  and alignment.

Use these to build custom Sketchy components without touching low-level rough
APIs.

### Roughness-aware fills

The library exposes `SketchyFillOptions` so you can control hachure gaps or line
weights (e.g., the progress bar uses denser fills for stronger contrast). Most
widgets read the theme roughness and adapt automatically.

### Isolated Material usage

While Sketchy is designed to be independent of Material, `SketchyApp` and
`TextField` use isolated Material contexts internally to provide advanced
text editing capabilities (like selection handles, cursors, and clipboard access)
without leaking Material styles into your app. You do **not** need to wrap your
app in `MaterialApp` or `Theme`; `SketchyApp` handles the necessary localization
delegates automatically.

---

## Using Sketchy widgets

Sketchy mirrors common UI building blocks. Highlights:

| Category   | Widgets                                                                                                     |
| ---------- | ----------------------------------------------------------------------------------------------------------- |
| Inputs     | `TextField`, `DropdownButton`, `Slider`, `Checkbox`, `Switch`, `Radio`, `CheckboxListTile`, `RadioListTile` |
| Actions    | `OutlinedButton`, `IconButton`, `Chip`                                                                      |
| Containers | `Card`, `ListTile`, `Divider`                                                                               |
| Feedback   | `Dialog`, `Tooltip`, `Chip`, `SketchyTypingIndicator`, `SnackBar`                                           |
| Navigation | `TabBar`, `AppBar`, `Scaffold`                                                                              |

### Quick examples

```dart
OutlinedButton(
  onPressed: saveNote,
  child: Text('Save', style: SketchyTheme.of(context).typography.label),
);

CheckboxListTile(
  value: wantsEmails,
  onChanged: (checked) =>
      setState(() => wantsEmails = checked ?? wantsEmails),
  title: Text('Email me weekly',
      style: SketchyTheme.of(context).typography.body),
  subtitle: const Text('Includes product updates + comics.'),
);

RadioListTile<String>(
  value: 'instant',
  groupValue: deliverySpeed,
  onChanged: (value) => setState(() => deliverySpeed = value ?? 'instant'),
  title: Text('Send instantly',
      style: SketchyTheme.of(context).typography.body),
);

// `CheckboxListTile` and `RadioListTile` keep the control and its label (any widget)
// in sync and makes the entire row tappable.

Slider(
  value: roughness,
  onChanged: (value) => setState(() => roughness = value),
  min: 0,
  max: 1,
);

Dialog(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Plan review', style: SketchyTheme.of(context).typography.title),
      const SizedBox(height: 16),
      const Text('Update palette + capture perf traces.'),
      Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      ),
    ],
  ),
);
```

Every widget respects the active `SketchyTheme`—colors swap immediately when you
change modes, and the roughness slider affects outlines/fills at once.

---

## Example gallery & docs

- Run `flutter run` inside `/example` to explore the design system board: theme
  picker, mode buttons, roughness slider, fonts, dialogs, demo forms, and every
  Sketchy widget scenario.
- Specs live under `specs/` (`design-system.md`, `technical_design.md`,
  `requirements.md`) with UX references and rationale.
- `example` hosts the gallery showing real layouts built purely with Sketchy widgets.

Use the gallery as your reference implementation—it demonstrates recommended
layout patterns, theming hooks, and roughness transitions.

---

## Customization recipes

### Change fonts

```dart
final theme = SketchyTheme.of(context);
final whimsical = theme.typography.copyWith(
  headline: theme.typography.headline.copyWith(fontFamily: 'xkcd'),
);

return SketchyTheme(
  data: theme.copyWith(typography: whimsical),
  child: child,
);
```

### Create a custom surface

```dart
SketchySurface(
  strokeColor: theme.inkColor,
  fillColor: theme.paperColor,
  padding: const EdgeInsets.all(12),
  createPrimitive: () => SketchyPrimitive.roundedRectangle(
    cornerRadius: 24,
    fill: SketchyFill.hachure,
  ),
  child: const Text('Sticky note'),
);
```

### Respond to mode changes

`SketchyThemeData` exposes `copyWith` and `fromTheme`. To toggle at runtime:

```dart
void _toggleMode() {
  setState(() {
    _theme = _theme == SketchyThemes.monochrome
        ? SketchyThemes.indigo
        : SketchyThemes.monochrome;
  });
}
```

Wrap your subtree with a new `SketchyTheme` using the updated theme.

---

## Testing & tooling

- **Analyze:** `flutter analyze`
- **Tests:** `flutter test`
- **Formatting:** Dart format conventions are enforced; no additional scripts.
- **Example smoke test:** run `flutter run` in `/example` to ensure the gallery
  still builds.

All pull requests must pass analyzer + tests. Avoid `print`, add docs for public
APIs, and keep lines ≤80 characters (per repo lint settings).

---

## Contributing

1. Fork + branch from `main` or `rearchitect`.
2. Add or update widgets inside `lib/src/widgets/`. Re-export through
   `lib/src/widgets/widgets.dart`.
3. Update the gallery and specs when introducing new components or significant
   behavior changes.
4. Run analyzer + tests before opening a PR.
5. Document any new APIs in this README and in the specs folder.

Ideas? Bug reports? Open an issue! We love seeing new rough widgets, color
modes, and theme experiments. Let's keep wireframes fun. ✍️

### Acknowledgements

- [wired_elements](https://github.com/KevinZhang19870314/wired_elements) – MIT
  License. The original hand-drawn widget kit that inspired Sketchy!
- [rough_flutter](https://github.com/acyment/flutter_rough) – MIT License. Fork
  of the rough renderer that powers Sketchy primitives.
- [Comic Shanns font](https://github.com/shannpersand/comic-shanns) – MIT
  License. The typeface bundled with Sketchy by default.
