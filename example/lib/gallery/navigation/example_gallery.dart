import 'dart:async' show unawaited;

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../pages/examples.dart';

/// Landing page that lists all example scenes.
class ExampleGallery extends StatefulWidget {
  const ExampleGallery({
    required this.onCycleMode,
    required this.roughness,
    required this.onRoughnessChanged,
    super.key,
  });

  /// Callback that cycles to the next mode.
  final VoidCallback onCycleMode;

  /// Global roughness value.
  final double roughness;

  /// Updates the global roughness.
  final ValueChanged<double> onRoughnessChanged;

  @override
  State<ExampleGallery> createState() => _ExampleGalleryState();
}

class _ExampleGalleryState extends State<ExampleGallery> {
  late SketchyExampleEntry _selected = sketchyExamples.first;

  void _openExample(BuildContext context, SketchyExampleEntry entry) {
    unawaited(
      Navigator.of(context).push(SketchyPageRoute(builder: entry.builder)),
    );
  }

  void _selectExample(SketchyExampleEntry entry) {
    setState(() => _selected = entry);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth <= 800;
      return _GalleryShell(
        onCycleMode: widget.onCycleMode,
        roughness: widget.roughness,
        onRoughnessChanged: widget.onRoughnessChanged,
        child: isCompact
            ? _buildCompactList(context)
            : _buildSplitView(context),
      );
    },
  );

  Widget _buildCompactList(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(24),
    itemBuilder: (context, index) {
      final entry = sketchyExamples[index];
      return _ExampleTile(
        entry: entry,
        selected: false,
        onTap: () => _openExample(context, entry),
      );
    },
    separatorBuilder: (context, _) => const SizedBox(height: 16),
    itemCount: sketchyExamples.length,
  );

  Widget _buildSplitView(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 340,
        child: ListView.separated(
          padding: const EdgeInsets.all(24),
          itemBuilder: (context, index) {
            final entry = sketchyExamples[index];
            return _ExampleTile(
              entry: entry,
              selected: entry.id == _selected.id,
              onTap: () => _selectExample(entry),
            );
          },
          separatorBuilder: (context, _) => const SizedBox(height: 16),
          itemCount: sketchyExamples.length,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Builder(
              key: ValueKey(_selected.id),
              builder: _selected.builder,
            ),
          ),
        ),
      ),
    ],
  );
}

class _GalleryShell extends StatelessWidget {
  const _GalleryShell({
    required this.child,
    required this.onCycleMode,
    required this.roughness,
    required this.onRoughnessChanged,
  });

  final Widget child;
  final VoidCallback onCycleMode;
  final double roughness;
  final ValueChanged<double> onRoughnessChanged;

  @override
  Widget build(BuildContext context) {
    final modeName = _describeMode(SketchyTheme.of(context).mode);
    return SketchyScaffold(
      appBar: SketchyAppBar(
        title: Text('Sketchy Examples — $modeName'),
        actions: [
          _ModeButton(onPressed: onCycleMode),
          const SizedBox(width: 12),
          SketchyTooltip(
            message: 'rough.',
            child: SizedBox(
              width: 220,
              child: SketchySlider(
                value: roughness,
                onChanged: onRoughnessChanged,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(padding: const EdgeInsets.all(24), child: child),
          ),
          const _MascotBadge(),
        ],
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.entry,
    required this.onTap,
    required this.selected,
  });

  final SketchyExampleEntry entry;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final typography = SketchyTypography.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SketchySurface(
        padding: const EdgeInsets.all(16),
        fillColor: selected
            ? theme.colors.secondary.withValues(alpha: 0.5)
            : theme.colors.paper,
        strokeColor: theme.colors.ink,
        createPrimitive: () => SketchyPrimitive.roundedRectangle(
          cornerRadius: theme.borderRadius,
          fill: selected ? SketchyFill.solid : SketchyFill.none,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.title, style: typography.title),
            const SizedBox(height: 8),
            Text(entry.description, style: typography.body),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SketchyTooltip(
      message: 'mode.',
      child: GestureDetector(
        onTap: onPressed,
        child: SketchySurface(
          width: 40,
          height: 40,
          padding: EdgeInsets.zero,
          fillColor: theme.colors.secondary,
          strokeColor: theme.colors.primary,
          createPrimitive: () =>
              SketchyPrimitive.rectangle(fill: SketchyFill.solid),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge();

  @override
  Widget build(BuildContext context) => Positioned(
    left: 24,
    bottom: 24,
    child: SketchyTooltip(
      message: 'meh.',
      child: SizedBox(
        width: 16,
        height: 16,
        child: Image.asset(
          'packages/sketchy_design_lang/assets/images/sketchy-mascot.png',
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

String _describeMode(SketchyColorMode mode) => switch (mode) {
  SketchyColorMode.white => 'White',
  SketchyColorMode.red => 'Red',
  SketchyColorMode.orange => 'Orange',
  SketchyColorMode.yellow => 'Yellow',
  SketchyColorMode.green => 'Green',
  SketchyColorMode.cyan => 'Cyan',
  SketchyColorMode.blue => 'Blue',
  SketchyColorMode.indigo => 'Indigo',
  SketchyColorMode.violet => 'Violet',
  SketchyColorMode.magenta => 'Magenta',
  SketchyColorMode.black => 'Black',
};
