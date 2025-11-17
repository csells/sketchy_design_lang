import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';
import 'surface.dart';

/// Material-free dropdown widget for Sketchy design language.
class SketchyDropdown<T> extends StatefulWidget {
  /// Creates a dropdown with the given [items] and [label].
  const SketchyDropdown({
    required this.label,
    required this.items,
    super.key,
    this.value,
    this.onChanged,
  });

  /// Field label shown above the dropdown.
  final String label;

  /// Options the user may select from.
  final List<T> items;

  /// Currently selected value.
  final T? value;

  /// Callback invoked when the selection changes.
  final ValueChanged<T?>? onChanged;

  @override
  State<SketchyDropdown<T>> createState() => _SketchyDropdownState<T>();
}

class _SketchyDropdownState<T> extends State<SketchyDropdown<T>> {
  final _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                child: _DropdownMenu<T>(
                  key: _overlayKey,
                  items: widget.items,
                  onItemSelected: (item) {
                    _closeDropdown();
                    widget.onChanged?.call(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    final theme = SketchyTheme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: typography.body),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _toggleDropdown,
            child: SketchySurface(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              fillColor: theme.colors.paper,
              strokeColor: theme.colors.ink,
              createPrimitive: () => SketchyPrimitive.roundedRectangle(
                cornerRadius: theme.borderRadius,
                fill: SketchyFill.none,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value?.toString() ?? '',
                      style: typography.body,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomPaint(
                    size: const Size(12, 8),
                    painter: _DownArrowPainter(color: theme.colors.ink),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.onItemSelected,
    super.key,
  });

  final List<T> items;
  final ValueChanged<T> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    final theme = SketchyTheme.of(context);

    return SketchySurface(
      padding: const EdgeInsets.all(8),
      fillColor: theme.colors.paper,
      strokeColor: theme.colors.ink,
      createPrimitive: () => SketchyPrimitive.roundedRectangle(
        cornerRadius: theme.borderRadius,
        fill: SketchyFill.solid,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items
                .map(
                  (item) => GestureDetector(
                    onTap: () => onItemSelected(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(item.toString(), style: typography.body),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _DownArrowPainter extends CustomPainter {
  _DownArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
