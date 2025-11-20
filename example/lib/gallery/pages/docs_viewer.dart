import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Tabbed document viewer with tooltips and copy buttons.
class DocsViewerExample extends StatefulWidget {
  const DocsViewerExample({super.key});

  static Widget builder(BuildContext context) => const DocsViewerExample();

  @override
  State<DocsViewerExample> createState() => _DocsViewerExampleState();
}

class _DocsViewerExampleState extends State<DocsViewerExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final typography = theme.typography;

      return SketchyScaffold(
        appBar: const SketchyAppBar(title: Text('Docs Viewer')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SketchyTabs(
                tabs: const ['Getting started', 'API reference', 'Cookbook'],
                selectedIndex: _index,
                onChanged: (value) => setState(() => _index = value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SketchyCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _docs[_index].title,
                                style: typography.headline,
                              ),
                            ),
                            SketchyTooltip(
                              message: 'copy link.',
                              child: SketchyIconButton(
                                icon: SketchyIcons.copy,
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: _docs[_index].title),
                                  );
                                  if (!context.mounted) return;
                                  SketchyToast.show(
                                    context,
                                    message: 'Link copied.',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const SketchyDivider(),
                        const SizedBox(height: 12),
                        ..._docs[_index].sections.map(
                          (section) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(section.title, style: typography.title),
                                const SizedBox(height: 4),
                                Text(section.body, style: typography.body),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DocSection {
  const _DocSection(this.title, this.body);
  final String title;
  final String body;
}

class _DocChapter {
  const _DocChapter(this.title, this.sections);
  final String title;
  final List<_DocSection> sections;
}

const _docs = [
  _DocChapter('Welcome to Sketchy', [
    _DocSection(
      'Install',
      'Add the sketchy_design_lang dependency and wrap your app with '
          'SketchyApp.',
    ),
    _DocSection(
      'Theme',
      'Use SketchyThemeData.light() or '
          'SketchyThemeData.dark() to configure '
          'ink & paper colors.',
    ),
  ]),
  _DocChapter('API reference', [
    _DocSection(
      'SketchyButton',
      'Primary, secondary, and ghost variants map cleanly onto '
          'Sketchy primitives.',
    ),
    _DocSection(
      'SketchyCard',
      'Wrap content with hand-drawn shells to create focus without importing '
          'Material.',
    ),
  ]),
  _DocChapter('Cookbook', [
    _DocSection(
      'List tiles',
      'Use SketchyListTile for navigable rows; pair with SketchyDivider for '
          'grouping.',
    ),
    _DocSection(
      'Annotations',
      'Use highlight callouts for onboarding or tours without relying on '
          'Material.',
    ),
  ]),
];
