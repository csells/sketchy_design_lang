import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ProgressSection extends StatefulWidget {
  const ProgressSection({super.key});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startProgress() {
    _progressController
      ..stop()
      ..reset();
    unawaited(_progressController.forward());
  }

  void _stopProgress() {
    _progressController.stop();
  }

  void _resetProgress() {
    _progressController.reset();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(controller: _progressController, value: 0),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _startProgress,
                child: Text(
                  'Start',
                  style: buttonLabelStyle(theme, color: theme.primaryColor),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _stopProgress,
                child: Text(
                  'Stop',
                  style: buttonLabelStyle(theme, color: theme.errorColor),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _resetProgress,
                child: Text('Reset', style: buttonLabelStyle(theme)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
