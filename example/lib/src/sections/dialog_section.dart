import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class DialogSection extends StatelessWidget {
  const DialogSection({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy dialog',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dialogs keep the same rough frame and '
            'Comic Shanns tone.',
            style: mutedStyle(theme),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            child: Text('Open dialog', style: buttonLabelStyle(theme)),
            onPressed: () {
              unawaited(
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Dismiss dialog',
                  barrierColor: theme.inkColor.withValues(alpha: 0.55),
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                            child: child,
                          ),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SketchyTheme.consumer(
                              builder: (ctx, dialogTheme) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This is a sketchy dialog.',
                                    style: titleStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'It has a title and some content.',
                                    style: bodyStyle(dialogTheme),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'Close',
                                          style: buttonLabelStyle(dialogTheme),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
