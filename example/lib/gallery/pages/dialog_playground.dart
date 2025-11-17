import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Example that shows a bespoke sketchy dialog overlay.
class SketchyDialogPlaygroundExample extends StatefulWidget {
  const SketchyDialogPlaygroundExample({super.key});

  static Widget builder(BuildContext context) =>
      const SketchyDialogPlaygroundExample();

  @override
  State<SketchyDialogPlaygroundExample> createState() =>
      _SketchyDialogPlaygroundExampleState();
}

class _SketchyDialogPlaygroundExampleState
    extends State<SketchyDialogPlaygroundExample> {
  bool _showDialog = false;

  void _toggleDialog() => setState(() => _showDialog = !_showDialog);

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Dialog Playground')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: SketchyCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design sessions', style: typography.headline),
                  const SizedBox(height: 12),
                  const SketchyListTile(
                    title: Text('Onboarding flow retrofit'),
                    subtitle: Text('Shared sprint with growth team.'),
                    trailing: SketchyBadge(
                      label: 'Due soon',
                      tone: SketchyBadgeTone.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SketchyButton.primary(
                    label: 'Review checklist dialog',
                    onPressed: _toggleDialog,
                  ),
                ],
              ),
            ),
          ),
          if (_showDialog)
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: SketchyPalette.scrim,
                  backgroundBlendMode: BlendMode.srcOver,
                ),
                child: Center(
                  child: SketchySurface(
                    width: 420,
                    padding: const EdgeInsets.all(24),
                    createPrimitive: () => SketchyPrimitive.roundedRectangle(
                      fill: SketchyFill.none,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Review checklist', style: typography.title),
                        const SizedBox(height: 16),
                        const SketchyDivider(),
                        const SizedBox(height: 12),
                        const Text('- Update color modes to latest palette.'),
                        const Text('- Add focus state examples.'),
                        const Text('- Gather perf traces for dashboard.'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SketchyButton.ghost(
                              label: 'Cancel',
                              onPressed: _toggleDialog,
                            ),
                            const SizedBox(width: 8),
                            SketchyButton.primary(
                              label: 'Mark complete',
                              onPressed: _toggleDialog,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
