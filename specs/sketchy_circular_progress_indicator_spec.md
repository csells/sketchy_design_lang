# Component Specification: SketchyCircularProgressIndicator

## 1. Overview

A circular progress indicator with a hand-drawn, "sketchy" aesthetic. It's designed to fit within the `sketchy_design_lang` ecosystem and uses the `rough_flutter` package via `SketchyPrimitive` and `SketchyShapePainter` for consistent sketchy rendering. This component can represent both determinate and indeterminate progress.

## 2. States

The component has two primary states:

### 2.1. Determinate

- **Trigger**: When a `value` between `0.0` and `1.0` is provided.
- **Visuals**: Displays a circular track (sketchy circle) and a progress arc representing the current value. The arc starts from the top (12 o'clock position, `-π/2` radians) and grows clockwise.
- **Behavior**: The arc length is proportional to the `value`. Values below `0.01` hide the progress arc entirely, and `1.0` shows a full circle.

### 2.2. Indeterminate

- **Trigger**: When `value` is `null`.
- **Visuals**: Displays a circular track with a pulsing arc that continuously rotates.
- **Behavior**: 
  - The arc animates along the track with continuous rotation (0 → 2π per cycle).
  - The arc length pulses between 75% and 100% of a full circle using an eased animation.
  - Animation duration is 2 seconds per full rotation cycle.

## 3. Visual Style ("Sketchy" Effect)

- The sketchy look is achieved using the `rough_flutter` library via `SketchyPrimitive` and `SketchyShapePainter`.
- The background track is rendered using `SketchyPrimitive.circle()` with reduced opacity (20%) and thinner stroke (60% of main stroke).
- The progress arc is rendered using `SketchyPrimitive.arc()` with configurable `startAngle` and `sweepAngle`.
- Arc rendering uses `generator.arc()` from rough_flutter with diameter-based dimensions to ensure proper circular arcs.
- The roughness is inherited from the current `SketchyTheme.roughness` value.

## 4. Theming

- **Color**: The indicator is fully themeable.
  - `color`: The progress arc color. Defaults to `SketchyTheme.primaryColor`.
  - `backgroundColor`: The track color. Defaults to the `color` value at 20% opacity.
  - `strokeWidth`: Line thickness for the progress arc. Background track uses 60% of this value.
  - `roughness`: Inherited from `SketchyTheme.roughness` for consistent look across the app.

## 5. API and Properties

| Property          | Type      | Description                                                           | Default Value |
| ----------------- | --------- | --------------------------------------------------------------------- | ------------- |
| `value`           | `double?` | The progress value between `0.0` and `1.0`. If `null`, indeterminate. | `null`        |
| `strokeWidth`     | `double`  | The thickness of the progress arc stroke.                             | `4.0`         |
| `size`            | `double?` | The width and height of the indicator widget.                         | `48.0`        |
| `color`           | `Color?`  | The color of the progress arc. Defaults to theme's `primaryColor`.    | `null`        |
| `backgroundColor` | `Color?`  | The color of the background track.                                    | `null`        |
| `semanticLabel`   | `String?` | Custom accessibility label for the indicator.                         | `null`        |

## 6. Implementation Details

### 6.1. Architecture

The component uses a layered approach with two stacked `CustomPaint` widgets:
1. **Background track**: A full sketchy circle with reduced opacity and stroke width.
2. **Foreground arc**: The progress arc that represents the current value.

### 6.2. Using SketchyPrimitive

The component uses `SketchyPrimitive` factories for shape definitions:

```dart
// Background track
SketchyPrimitive.circle(seed: _fixedSeed)

// Progress arc
SketchyPrimitive.arc(
  seed: _fixedSeed,
  startAngle: -pi / 2 + spinOffset,
  sweepAngle: value * 2 * pi,
)
```

### 6.3. Deterministic Rendering

- A fixed seed (`12345`) is used for both primitives to ensure consistent sketchy appearance across frames.
- The `SketchyPrimitive` equality and hashCode include `startAngle` and `sweepAngle` to ensure proper cache invalidation when angles change.

### 6.4. Animation

- Uses `AnimationController` with `TickerProviderStateMixin` for efficient animation.
- **Spin Animation**: Linear tween from 0 to 1, multiplied by 2π to create continuous rotation.
- **Progress Animation**: Eased animation between 0.75 and 1.0 for the indeterminate arc length pulse (runs in first 50% of the animation interval).
- Animation duration: 2 seconds per cycle.
- The controller calls `repeat()` to run indefinitely for indeterminate mode.

### 6.5. Arc Rendering Details

The arc is rendered using `rough_flutter`'s `generator.arc()` method:
- Uses diameter-based dimensions (`min(size.width, size.height)`) for both width and height to ensure circular arcs.
- Start angle defaults to `-π/2` (top of circle) plus any spin offset.
- Sweep angle is calculated as `value * 2 * π`.

## 7. Accessibility

- The indicator is wrapped in a `Semantics` widget.
- Provides a default label "Circular progress indicator".
- Shows percentage value for determinate mode (e.g., "75%").
- Custom `semanticLabel` can be provided to override the default label.

```dart
Semantics(
  label: widget.semanticLabel ?? 'Circular progress indicator',
  value: widget.value != null
      ? '${(widget.value! * 100).round()}%'
      : null,
  child: ...
)
```

## 8. Caching

- `SketchyGenerator` maintains an internal cache keyed by `primitive.hashCode`.
- Cache entries store `(Size, double roughness, Drawable)` tuples.
- Cache is invalidated when size or roughness changes, or when primitive properties (including angles) change.
- This ensures efficient re-rendering during animations while still updating when necessary.

## 9. Widget Dimensions

- The indicator dimension is configurable via the `size` parameter.
- Default dimension is `48x48` logical pixels.
- The arc and circle primitives are rendered to fill the available space using `SizedBox.expand()`.

## 10. Performance Considerations

- Uses `AnimatedBuilder` with merged `Listenable` for efficient rebuilds.
- `SketchyShapePainter.shouldRepaint()` returns true only when visual properties change.
- Fixed seed ensures consistent sketchy appearance without regenerating random paths.
- Drawable caching prevents redundant rough path generation for unchanged primitives.
- Arc visibility check (`value > 0.01`) prevents rendering negligible arcs.

## 11. Dependencies

- `rough_flutter`: For sketchy/hand-drawn rendering effects.
- `SketchyPrimitive`: Data class for shape configuration.
- `SketchyShapePainter`: Custom painter for rendering primitives.
- `SketchyTheme`: For accessing theme values (primaryColor, roughness).

## 12. Usage Examples

### Basic Indeterminate

```dart
const SketchyCircularProgressIndicator()
```

### Determinate with Value

```dart
SketchyCircularProgressIndicator(
  value: 0.75,
)
```

### Custom Styling

```dart
SketchyCircularProgressIndicator(
  value: 0.5,
  size: 64,
  strokeWidth: 6.0,
  color: Colors.blue,
  backgroundColor: Colors.blue.withOpacity(0.1),
)
```

### With Custom Accessibility Label

```dart
SketchyCircularProgressIndicator(
  value: downloadProgress,
  semanticLabel: 'Download progress',
)
```
