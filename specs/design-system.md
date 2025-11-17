# Sketchy Design System

Sketchy is a hand-drawn, xkcd-inspired design system for Flutter apps (mobile,
desktop, and web).  
It combines:

- **Comic Shanns** as the primary typeface  
- **`wired_elements`** as the widget library that gives everything a sketched
  look  
- A small set of **color themes** based on ROYGBIV (+ friends)  
- A bemused yellow face mascot that represents the “low-fi but honest” attitude
  of the system  

Sketchy is ideal for:

- Prototypes where you want to emphasize **ideas over pixels**
- “Living wireframes” that behave like a real app
- Production apps that intentionally lean into a playful, comic-style aesthetic

---

## Design Principles

1. **Intentional roughness**  
   Straight lines are suspicious. Borders wobble, circles are lopsided, and
   that’s the point.

2. **Clarity first**  
   Comic Shanns is fun, but still highly readable. Layout and hierarchy should
   be clear even when the lines are messy.

3. **Low-stakes visuals**  
   Sketchy should make designs feel approachable and changeable. Nothing looks
   “finished” enough to be sacred.

4. **Consistency under the chaos**  
   Behind the loose look is a consistent set of tokens, themes, and components
   so implementation stays solid.

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

Each theme has a:

- **Primary color** – used for accents, app bars, highlights  
- **Secondary color** – used for softer surfaces, fills and backgrounds  

In **light mode**, the primary and secondary colors are used as defined.  
In **dark mode**, **primary and secondary swap roles**:

- primary ⇄ secondary  

This makes dark mode feel like the same world, just inverted.

Example (conceptual):

| Theme      | Primary (light) | Secondary (light) |
| ---------- | --------------- | ----------------- |
| monochrome | Black           | Light gray        |
| red        | Bright red      | Soft pink         |
| blue       | Bright blue     | Pale blue         |
| …          | …               | …                 |

---

### Mascot

- **Name:** (TBD, but currently “Meh” in spirit)
- **Appearance:** Yellow circular face, simple eyes, horizontal “meh” mouth
- **Usage:**
  - Prominent in design-system docs and “about” screens
  - Optional avatar for empty states or playful onboarding
  - Avoid overuse in critical UX (e.g., error dialogs should be clearer than
    “meh”)

---

### Line Style & Shapes

The look is powered by `wired_elements`:

- Double-line, jittery rectangles and circles
- Slight randomness in stroke path
- Minimal corner radius (mostly rectangular) but visually softened by stroke
  wobble

Guidelines:

- Prefer **wired components** for core UI surfaces in Sketchy contexts  
- Keep layouts relatively simple—too many sketchy outlines in one place can
  become noisy

---

## Modes & Themes

### Light Mode

- Background: off-white / paper-like  
- Primary color: theme primary  
- Secondary color: theme secondary  
- Shadows are minimal; hierarchy is driven more by layout and outline than
  elevation.

### Dark Mode

- Background: very dark gray / near-black  
- Primary color: theme secondary (swapped)  
- Secondary color: theme primary (swapped)  
- Text uses lighter gray/white; outlines remain clearly visible.

Mode switching is exposed via a Sketchy-styled toggle (two buttons: **Light**
and **Dark**, both wired buttons).

---

## Tokens

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

Each theme & mode pair maps these tokens to actual colors; the widgets use the
tokens, not raw values.

### Spacing & Layout

A simple, coarse scale:

- `space.xs` = 4
- `space.sm` = 8
- `space.md` = 12
- `space.lg` = 16
- `space.xl` = 24

Use these for padding, margins, and gaps between components.

### Stroke / Outline

- Stroke thickness is generally between **1.5–2.5 px**, but the visual wobble
  makes it feel looser.
- Outlines should stay consistent within a view (don’t mix very thin and very
  thick wired elements on the same screen).

---

## Component Library

All components are built on `wired_elements` and renamed conceptually as
**Sketchy** components.

### 1. Sketchy Buttons

**Base widget:** `WiredButton`

Variants:

- Primary Sketchy Button  
- Secondary actions like **Submit**, **Cancel**  
- Long-label buttons, e.g., `Long text button … hah`

Guidelines:

- Use short, conversational labels.
- Keep main CTAs visually clear—position and spacing matter more than color in
  this style.

---

### 2. Sketchy Divider

**Base widget:** `WiredDivider`

Used to:

- Separate paragraphs or sections of content
- Divide stacked blocks like cards or form sections

Typical layout:

- Heading (`Sketchy divider`)
- Paragraph of Comic-Shanns lorem
- Divider
- Another paragraph

---

### 3. Sketchy Text Input

**Base widget:** `WiredInput`

Examples:

- **Name** – text input with “Hello sketchy input”
- **User Email** – “Please enter user email”
- **Your age** – “Your age please!”

Guidelines:

- Labels are plain Comic Shanns text outside the input; placeholders inside are
  light and conversational.
- Inputs should have generous width and space between them, to stay legible
  despite the sketchy border.

---

### 4. Sketchy Radio

**Base widget:** `WiredRadio`

Example options:

- `Lafayette`
- `Thomas Jefferson`

Guidelines:

- Ideal for small sets of mutually exclusive choices.
- Keep labels simple and padded; the hand-drawn circles are part of the charm.

---

### 5. Sketchy Slider

**Base widget:** `WiredSlider`

Used for:

- Selecting numeric ranges or percentages (e.g., value label: `20`)

Guidelines:

- Show a numeric value next to or above the slider (Sketchy is playful, but
  still explicit).
- Prefer sliders for approximate selection, not precise numeric input.

---

### 6. Sketchy Progress

**Base widget:** `WiredProgress`

Common pattern:

- Progress bar
- Three Sketchy buttons: **Start**, **Stop**, **Reset**

Guidelines:

- Progress changes should be visible but not overly animated; the hand-drawn
  fill is already visually engaging.
- Use for longer operations where feedback matters but isn’t critical-path (file
  uploads, background tasks, etc.).

---

### 7. Sketchy Calendar

**Base widget:** `WiredCalendar`

Example:

- Month view for **July 2021** with a circled date (e.g., the 22nd).

Guidelines:

- Designed for picking single dates.
- Use Sketchy text for month name and weekday labels.
- Highlight the selected date with a scribbled circle, not a solid fill, to
  preserve the sketch style.

---

## Layout Patterns

Sketchy screens follow a simple structure:

- **Header row**  
  - Mascot on the left  
  - Title (“Sketchy Design System”) and subtitle  
  - Optional mode/theme metadata

- **Theme strip**  
  - Primary and secondary color dots for each theme  
  - Tapping a theme updates the global palette

- **Mode row**  
  - Sketchy buttons for **Light** and **Dark**

- **Component grid**  
  - Sections grouped in Sketchy cards (wired rectangles with padding)  
  - Each card has: title + components + brief description/lorem

The “design system board” page is itself an example of how to lay out Sketchy
content.

---

## Implementation Notes (Flutter)

- **Packages**
  - `wired_elements` – provides the sketchy UI primitives.
  - `Comic Shanns` – added as a custom font in `pubspec.yaml`.

- **Theme**
  - Defined via `ThemeData` with `fontFamily: 'ComicShanns'`.
  - `ColorScheme.fromSeed` is used per theme to keep Material integrations sane.
  - Dark mode is implemented using `ThemeMode` and swapping primary/secondary.

- **Palette Model**
  - `SketchyPalette` struct with `name`, `primary`, `secondary`.
  - A simple map of theme name → `SketchyPalette`.

The design system page is a single `Scaffold` with a scrollable, responsive
layout (works on mobile, desktop, and web).

---

## Accessibility

Even though Sketchy looks informal, it should still be accessible:

- Ensure **contrast** between text and background (especially in dark mode).
- Preserve reasonable **touch targets** for buttons and inputs (at least 44×44
  dp).
- Provide clear **focus states** and keyboard navigation on desktop/web.
- Use meaningful labels for iconography and dismissive actions (e.g., avoid
  purely visual “meh” faces for critical messaging).

---

## Usage Guidelines

Use Sketchy when:

- You’re building an internal prototype or workshop tool.
- You want to deliberately avoid “production-polished” visuals.
- You’re presenting options and want stakeholders to focus on **flows and
  content**, not detailed UI polish.

Avoid Sketchy when:

- You’re designing a brand that depends on a very serious or formal tone.
- You need pixel-perfect adherence to an established corporate design system.
- High-stakes, high-stress UX requires maximum clarity and calm (e.g., medical,
  finance alerts).

---

## Roadmap Ideas

Future extensions of the Sketchy design system could include:

- Sketchy **tabs**, **chips**, and **badges**
- Sketchy **dialogs**, **toasts**, and **inline alerts**
- A small **icon set** in the same hand-drawn style
- Design tokens exported for web and other platforms (JSON, CSS, etc.)
- Figma / design-tool libraries that mirror the Flutter implementation

---

**Summary**

Sketchy turns your app into a living comic-book UI: playful lines, clear
typography, and ROYGBIV-powered themes, all wired together with a consistent set
of tokens and components. It’s a design system that doesn’t pretend to be
perfect, which makes it a great companion for exploring ideas quickly—and
sometimes shipping them.
