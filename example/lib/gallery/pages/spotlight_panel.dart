import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Example card demonstrating annotations over hero content.
class SketchySpotlightPanelExample extends StatelessWidget {
  const SketchySpotlightPanelExample({super.key});

  static Widget builder(BuildContext context) =>
      const SketchySpotlightPanelExample();

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);

    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Spotlight Panel')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SketchyCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SketchyBadge(label: 'Beta'),
                    const SizedBox(height: 12),
                    Text('Team Hub', style: typography.headline),
                    const SizedBox(height: 8),
                    Text(
                      'Spin up a collaborative canvas that feels like a living '
                      'wireframe. Invite teammates, drop sketches, and layer '
                      'annotations in seconds.',
                      style: typography.body,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SketchyButton(
                            onPressed: () {},
                            child: Text('Create hub', style: typography.label),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SketchyButton(
                            onPressed: () {},
                            child: Text(
                              'Browse templates',
                              style: typography.label,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
