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
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() => runApp(const SketchyDemo());

class SketchyDemo extends StatelessWidget {
  const SketchyDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final base = SketchyThemeData.fromMode(
      SketchyColorMode.blue,
      roughness: 0.7,
    );

    return SketchyApp(
      title: 'Sketchy Demo',
      theme: base,
      darkTheme: base.copyWith(
        colors: base.colors.copyWith(
          primary: base.colors.secondary,
          secondary: base.colors.primary,
          ink: base.colors.secondary,
          paper: base.colors.primary,
        ),
      ),
      themeMode: SketchyThemeMode.system,
      home: const SketchyScaffold(
        appBar: SketchyAppBar(title: Text('Wireframe Vibes')),
        body: Center(child: SketchyButton(child: Text('Do the thing'))),
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

- **Colors** – ink, paper, primary/secondary, scrim, accent badges. Modes include
  monochrome plus Red → Violet families. Dark mode swaps ink/paper automatically.
- **Roughness** – a 0–1 dial that controls wobble, bowing, hachure spacing, and
  randomness (0 = crisp, 1 = sketchbook chaos).
- **Typography** – defaults to Comic Shanns but you can swap entire families via
  `copyWith`.
- **TextCase** – transforms all text display (labels, headers, tooltips, etc.)
  with four options: `none` (default), `allCaps`, `titleCase`, `allLower`.
  Does NOT affect actual user input. For maximum sketchy vibes, try
  `xkcd` font + `TextCase.allCaps`.
- **Stroke width & border radius** – consistent outlines for every widget.

Access the theme with `SketchyTheme.of(context)` or granular helpers like
`SketchyTypography.of(context)`.

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

---

## Using Sketchy widgets

Sketchy mirrors common UI building blocks. Highlights:

| Category   | Widgets                                                                                                 |
| ---------- | ------------------------------------------------------------------------------------------------------- |
| Inputs     | `SketchyTextInput`, `SketchyCombo`, `SketchySlider`, `SketchyCheckbox`, `SketchyToggle`, `SketchyRadio` |
| Actions    | `SketchyButton`, `SketchyIconButton`, `SketchyChip`                                                     |
| Containers | `SketchyCard`, `SketchyPanel`, `SketchyListTile`, `SketchyDivider`                                      |
| Feedback   | `SketchyDialog`, `SketchyTooltip`, `SketchyBadge`, `SketchyTypingIndicator`                             |
| Navigation | `SketchyTabs`, `SketchyAppBar`, `SketchyScaffold`                                                       |

### Quick examples

```dart
SketchyButton(
  onPressed: saveNote,
  child: Text('Save', style: SketchyTheme.of(context).typography.label),
);

SketchyCheckbox(
  value: wantsEmails,
  onChanged: (checked) => setState(() => wantsEmails = checked ?? false),
);

SketchySlider(
  value: roughness,
  onChanged: (value) => setState(() => roughness = value),
  min: 0,
  max: 1,
);

SketchyDialog(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Plan review', style: SketchyTheme.of(context).typography.title),
      const SizedBox(height: 16),
      const Text('Update palette + capture perf traces.'),
      Align(
        alignment: Alignment.centerRight,
        child: SketchyButton(
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
- `example/lib/gallery` hosts focused pages (calendar planner, expense tracker,
  docs viewer, etc.) showing real layouts built purely with Sketchy widgets.

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
  strokeColor: theme.colors.ink,
  fillColor: theme.colors.paper,
  padding: const EdgeInsets.all(12),
  createPrimitive: () => SketchyPrimitive.roundedRectangle(
    cornerRadius: 24,
    fill: SketchyFill.hachure,
  ),
  child: const Text('Sticky note'),
);
```

### Respond to mode changes

`SketchyThemeData` exposes `copyWith` and `fromMode`. To toggle at runtime:

```dart
void _toggleMode() {
  setState(() {
    _mode = _mode == SketchyColorMode.white
        ? SketchyColorMode.indigo
        : SketchyColorMode.white;
  });
}
```

Wrap your subtree with a new `SketchyTheme` using the updated mode.

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
2. Add or update widgets inside `lib/src/sketchy_widgets/`. Re-export through
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
