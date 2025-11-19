# Sketchy Design System (Flutter)

Sketchy is ahand-drawn, xkcd-inspired design language for Flutter mobile,
desktop and web. It's powered by the wired_elements code, the rough_flutter
package and the Comic Shanns font.

---

## Design Principles

1. **Intentional roughness**  
   Straight lines are suspicious. Borders wobble and circles are lopsided on
   purpose. If you're gentle or performance-conscious, you can dial down the
   roughness to your preference.

2. **Clarity first**  
   Comic Shanns is fun but highly readable. Layout and hierarchy must stay clear
   even when the lines are messy. The example shows how to swap in the official
   xkcd or Excalifont fonts if you'd rather.

3. **Low-stakes visuals**  
   Sketchy should make designs feel approachable and changeable. Nothing looks
   “finished” enough to be sacred.

4. **Consistency under the chaos**  
   Behind the loose look is a consistent set of colors, styles and and widgets
   so the implementation stays solid. It may look rough, but each primitive gets
   its own seed so that it re-draws itself uniquely but consistently.

---

## Visual Language

### Typeface

- **Primary font:** `Comic Shanns` (from
  https://github.com/shannpersand/comic-shanns)  
- **Usage:**
  - Display / titles: larger sizes, bold
  - Body copy: regular weight, generous line height
  - Labels & captions: small but still comfortably readable

The entire app uses Comic Shanns via `ThemeData.fontFamily`.

---

### Color System

Sketchy defines a base set of themes:

- `monochrome`
- `red`
- `orange`
- `yellow`
- `green`
- `blue`
- `indigo`
- `violet`

Each theme has:

- **Primary color** – accents, app bars, highlights  
- **Secondary color** – softer surfaces, chips, subtle fills  

In **light mode**, the primary and secondary colors are used as defined.  
In **dark mode**, **primary and secondary swap roles**:

- primary ⇄ secondary  

This makes dark mode feel like the same world, just inverted.

Conceptually:

| Theme      | Primary (light) | Secondary (light) |
| ---------- | --------------- | ----------------- |
| monochrome | Black           | Light gray        |
| red        | Bright red      | Soft pink         |
| blue       | Bright blue     | Pale blue         |
| …          | …               | …                 |

---

### Line Style & Shapes

The rough look is powered by the code from **`wired_elements`**:

- Double-line, jittery rectangles and circles
- Slight randomness in stroke path
- Rectangular shapes that feel hand-drawn rather than geometric

Guidelines:

- Prefer Sketchy components (which wrap `wired_elements`) for all visible UI.
- Keep layouts simple—too many outlined things crowded together becomes visually
  noisy.

---

## Modes & Themes

### Light Mode

- Background: off-white / paper-like (`#FFFDF6` by default)  
- Primary color: theme primary  
- Secondary color: theme secondary  
- Shadows are minimal; hierarchy is driven mostly by layout, stroke, and color.

### Dark Mode

- Background: very dark gray / near black  
- Primary color: **secondary** from the selected theme (swapped)  
- Secondary color: **primary** from the selected theme (swapped)  
- Text uses light grays / white; outlines remain clearly visible.

Mode switching is exposed via Sketchy-styled toggle buttons: **Light** and
**Dark**.

---

## Tokens (Conceptual)

Even though the look is rough, the system is token-driven.

### Color Tokens

At minimum:

- `color.primary`
- `color.secondary`
- `color.background`
- `color.surface`
- `color.text.primary`
- `color.text.muted`
- `color.border.default`
- `color.accent.success`
- `color.accent.error`
- `color.accent.warning`

Each theme & mode pair maps these tokens to actual colors; Sketchy components
use tokens, not raw color literals.

### Spacing & Layout

A simple scale:

- `space.xs` = 4
- `space.sm` = 8
- `space.md` = 12
- `space.lg` = 16
- `space.xl` = 24

Use these for padding, margins, and inter-component gaps.

### Stroke / Outline

- Stroke thickness ~ **1.5–2.5 px**, but visually varied by jitter.
- Outlines should stay roughly consistent within a screen (don’t mix ultra-thin
  and heavy strokes).

---

## Flutter-Specific Implementation

In Flutter terms, Sketchy is a reusable **design system package** that apps
depend on.

It has three main layers:

1. **Tokens layer** – Dart types and `ThemeData` / `ThemeExtension`s  
2. **Components layer** – `Sketchy*` widgets built from tokens +
   `wired_elements`  
3. **Docs layer** – the in-app “Sketchy Design System” screen itself  

### Package & Folder Structure

Recommended layout:

```text
lib/
  sketchy.dart                     # public exports

  src/
    tokens/
      sketchy_palette.dart         # color/theme model (light/dark swap)
      sketchy_spacing.dart         # spacing constants
      sketchy_typography.dart      # Comic Shanns text styles
      sketchy_theme_ext.dart       # ThemeExtension bundling Sketchy tokens

    components/
      sketchy_button.dart
      sketchy_input.dart
      sketchy_divider.dart
      sketchy_radio.dart
      sketchy_slider.dart
      sketchy_progress.dart
      sketchy_calendar.dart

    docs/
      sketchy_design_system_page.dart
````

* **Apps import `package:sketchy/sketchy.dart`**, not `wired_elements` directly.
* `wired_elements` is an implementation detail hidden in `components/`.

### Tokens as Code

Sketchy tokens are **Dart APIs**, not just conceptual names.

#### Palette

A theme color pair:

```dart
class SketchyPalette {
  final String name;
  final Color primary;
  final Color secondary;

  const SketchyPalette({
    required this.name,
    required this.primary,
    required this.secondary,
  });
}
```

#### Theme Extension

`SketchyTheme` wraps palette + spacing + any derived colors:

```dart
@immutable
class SketchyTheme extends ThemeExtension<SketchyTheme> {
  final SketchyPalette palette;
  final double spaceSmall;
  final double spaceMedium;
  final double spaceLarge;

  const SketchyTheme({
    required this.palette,
    this.spaceSmall = 8,
    this.spaceMedium = 12,
    this.spaceLarge = 16,
  });

  @override
  SketchyTheme copyWith({
    SketchyPalette? palette,
    double? spaceSmall,
    double? spaceMedium,
    double? spaceLarge,
  }) {
    return SketchyTheme(
      palette: palette ?? this.palette,
      spaceSmall: spaceSmall ?? this.spaceSmall,
      spaceMedium: spaceMedium ?? this.spaceMedium,
      spaceLarge: spaceLarge ?? this.spaceLarge,
    );
  }

  @override
  SketchyTheme lerp(ThemeExtension<SketchyTheme>? other, double t) {
    if (other is! SketchyTheme) return this;
    return this; // non-animated for now; can be refined later
  }
}
```

Added to the app theme:

```dart
ThemeData buildSketchyTheme(SketchyPalette palette, Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    fontFamily: 'ComicShanns',
    colorScheme: ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
    ),
  );

  return base.copyWith(
    extensions: <ThemeExtension<dynamic>>[
      SketchyTheme(palette: palette),
    ],
  );
}
```

Widgets read tokens with:

```dart
final sketchy = Theme.of(context).extension<SketchyTheme>()!;
final primary = sketchy.palette.primary;
```

This keeps **tokens as the single source of truth** for all Sketchy components.

### Sketchy Components as the Public API

Each public Sketchy widget wraps its `wired_elements` counterpart and
automatically applies tokens:

* `SketchyButton` → wraps `WiredButton`
* `SketchyInput` → wraps `WiredInput`
* `SketchyDivider` → wraps `WiredDivider`
* `SketchyRadio<T>` → wraps `WiredRadio<T>`
* `SketchySlider` → wraps `WiredSlider`
* `SketchyProgress` → wraps `WiredProgress`
* `SketchyCalendar` → wraps `WiredCalendar`

Example usage from an app:

```dart
SketchyButton.primary(
  onPressed: () {},
  label: 'Submit',
);
```

App code **never talks to `WiredButton` directly**; that lets Sketchy evolve
internals without breaking consumers.

### Docs as Part of the System

The **Sketchy Design System page** is a first-class artifact:

* Shows **all tokens** (palettes, theme names, light/dark swap behavior).
* Shows **all components** in representative states with realistic content.
* Acts as a **storybook** for designers and engineers.

You can:

* Ship it as a separate `sketchy_docs` entrypoint, or
* Expose it behind a debug-only route in the consuming app.

### Testing & Governance

To keep Sketchy stable as it grows:

* Use **golden tests** for core Sketchy widgets to catch visual regressions.
* Add **widget tests** for theming behavior (e.g., verifying primary/secondary
  swap in dark mode).
* Version Sketchy as a standalone package; document:

  * Supported Flutter SDK versions
  * Breaking changes (token shifts, widget API changes)
  * Deprecation paths for old widgets or props

---

## Component Library

All components are built on `wired_elements` and exposed as **Sketchy** widgets.

### 1. Sketchy Buttons

**Base widget:** `SketchyButton` (wraps `WiredButton`)

Variants (examples):

* Primary Sketchy Button
* Secondary actions like **Submit**, **Cancel**
* Long-label buttons, e.g., `Long text button … hah`

Guidelines:

* Use short, conversational labels.
* Use layout and grouping to communicate importance (CTAs at the bottom or in
  consistent positions).

---

### 2. Sketchy Divider

**Base widget:** `SketchyDivider` (wraps `WiredDivider`)

Used to:

* Separate paragraphs or sections of content
* Divide stacked blocks like cards or form sections

Typical layout:

* Heading (`Sketchy divider`)
* Paragraph of body text
* Divider
* Another paragraph

---

### 3. Sketchy Text Input

**Base widget:** `SketchyInput` (wraps `WiredInput`)

Examples:

* **Name** – placeholder “Hello sketchy input”
* **User Email** – “Please enter user email”
* **Your age** – “Your age please!”

Guidelines:

* Use Comic Shanns labels outside the input; placeholders inside are light and
  friendly.
* Keep horizontal padding generous; the jittery border needs breathing room.

---

### 4. Sketchy Radio

**Base widget:** `SketchyRadio<T>` (wraps `WiredRadio<T>`)

Example options:

* `Lafayette`
* `Thomas Jefferson`

Guidelines:

* Best for small sets of mutually exclusive options.
* Keep labels concise, with at least `space.sm` between options vertically.

---

### 5. Sketchy Slider

**Base widget:** `SketchySlider` (wraps `WiredSlider`)

Usage:

* Selecting approximate numeric values (e.g., percentage, volume, rating)

Guidelines:

* Always accompany with a live numeric or semantic label: `Value: 20` or `Loud`,
  `Normal`, etc.
* Prefer for “feel” adjustments, not exact numbers.

---

### 6. Sketchy Progress

**Base widget:** `SketchyProgress` (wraps `WiredProgress`)

Pattern:

* A progress bar showing completion fraction
* Control buttons: **Start**, **Stop**, **Reset**

Guidelines:

* Use for background operations or async tasks where feedback is helpful but not
  life-or-death.
* Avoid overly long animations—the scribbled fill is already visually busy.

---

### 7. Sketchy Calendar

**Base widget:** `SketchyCalendar` (wraps `WiredCalendar`)

Example:

* Month view for a given year, with the selected date scribble-circled.

Guidelines:

* Designed primarily for **single date selection**.
* Use Sketchy typography for month and weekday labels.
* Selected date should be clearly indicated but still feel hand-drawn.

---

## Layout Patterns

Sketchy screens follow a straightforward structure:

1. **Header row**

   * Mascot on the left
   * Title (“Sketchy Design System”) and subtitle
   * Optional mode/theme metadata

2. **Theme strip**

   * Primary and secondary color dots for each theme
   * Tapping a theme updates the global palette

3. **Mode row**

   * Sketchy Light/Dark buttons

4. **Component grid**

   * Each group of components lives inside a Sketchy card:

     * Section title
     * Demo components
     * Optional supporting text

The design-system board itself is a concrete reference layout.

---

## Accessibility

Sketchy looks informal, but it should still be accessible:

* Maintain **contrast** between text and background in all themes/modes.
* Keep touch targets ≥ 44×44 dp.
* Provide clear **focus states** for keyboard and assistive-tech navigation.
* Use descriptive labels and semantics for interactive elements (`Semantics`,
  `aria` on web).
* Don’t rely solely on color (or squiggles) to signal critical states.

---

## Usage Guidelines

Use Sketchy when:

* You’re prototyping interaction flows or data structures.
* You want stakeholders to focus on **what** the app does, not **how polished**
  it looks.
* You’re building internal tools or playful apps where the aesthetic matches the
  brand.

Avoid Sketchy when:

* You need a serious, formal brand tone (e.g., banking, medical emergencies).
* Your design must match a rigid corporate design system.
* High-stress flows require maximum calm and clarity.

---

## Roadmap Ideas

Potential future extensions:

* Sketchy **tabs**, **chips**, **badges**, and **toasts**
* Sketchy **dialogs**, inline alerts, and banners
* A small **sketchy icon set** (monochrome but tintable)
* Figma / design-tool libraries that mirror the Flutter implementation
* JSON / CSS export of tokens for non-Flutter surfaces

---

**Summary**

Sketchy is a Flutter-first design system that turns your app into a living
comic-book UI: playful lines, clear Comic Shanns typography, ROYGBIV-powered
themes, and a consistent set of tokens & widgets built on top of
`wired_elements`. It’s intentionally rough, structurally solid, and designed to
keep conversations centered on user flows and behavior—not pixel-perfect polish.