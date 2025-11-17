import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Demonstrates checkboxes, radio buttons, sliders, and progress.
class SketchyControlLabExample extends StatefulWidget {
  const SketchyControlLabExample({super.key});

  static Widget builder(BuildContext context) =>
      const SketchyControlLabExample();

  @override
  State<SketchyControlLabExample> createState() =>
      _SketchyControlLabExampleState();
}

class _SketchyControlLabExampleState extends State<SketchyControlLabExample> {
  bool _emailAlerts = true;
  bool _smsAlerts = false;
  String _priority = 'medium';
  double _focus = 0.55;

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Control Lab')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SketchyCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification routing', style: typography.headline),
              const SizedBox(height: 12),
              SketchyCheckboxTile(
                label: 'Email summary',
                value: _emailAlerts,
                onChanged: (value) => setState(() => _emailAlerts = value),
              ),
              const SizedBox(height: 8),
              SketchyCheckboxTile(
                label: 'SMS for urgent threads',
                value: _smsAlerts,
                onChanged: (value) => setState(() => _smsAlerts = value),
              ),
              const SizedBox(height: 24),
              Text('Escalation priority', style: typography.title),
              const SizedBox(height: 8),
              SketchyRadioTile<String>(
                title: 'Low-key',
                value: 'low',
                groupValue: _priority,
                onChanged: (value) =>
                    setState(() => _priority = value ?? 'low'),
              ),
              SketchyRadioTile<String>(
                title: 'Normal',
                value: 'medium',
                groupValue: _priority,
                onChanged: (value) =>
                    setState(() => _priority = value ?? 'medium'),
              ),
              SketchyRadioTile<String>(
                title: 'Page me immediately',
                value: 'high',
                groupValue: _priority,
                onChanged: (value) =>
                    setState(() => _priority = value ?? 'high'),
              ),
              const SizedBox(height: 24),
              Text('Focus window', style: typography.title),
              const SizedBox(height: 8),
              SketchySlider(
                value: _focus,
                onChanged: (value) => setState(() => _focus = value),
              ),
              const SizedBox(height: 12),
              Text(
                'Context swap confidence: ${(_focus * 100).round()}%',
                style: typography.caption,
              ),
              const SizedBox(height: 8),
              SketchyProgressBar(value: _focus),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SketchyButton.primary(
                      label: 'Apply routine',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SketchyButton.secondary(
                      label: 'Reset',
                      onPressed: () {
                        setState(() {
                          _emailAlerts = true;
                          _smsAlerts = false;
                          _priority = 'medium';
                          _focus = 0.55;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
