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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notification routing', style: typography.headline),
                const SizedBox(height: 12),
                _checkboxTile(
                  context,
                  label: 'Email summary',
                  value: _emailAlerts,
                  onChanged: (value) => setState(() => _emailAlerts = value),
                ),
                const SizedBox(height: 8),
                _checkboxTile(
                  context,
                  label: 'SMS for urgent threads',
                  value: _smsAlerts,
                  onChanged: (value) => setState(() => _smsAlerts = value),
                ),
                const SizedBox(height: 24),
                Text('Escalation priority', style: typography.title),
                const SizedBox(height: 8),
                _radioTile(
                  context,
                  title: 'Low-key',
                  value: 'low',
                  groupValue: _priority,
                  onChanged: (value) =>
                      setState(() => _priority = value ?? 'low'),
                ),
                _radioTile(
                  context,
                  title: 'Normal',
                  value: 'medium',
                  groupValue: _priority,
                  onChanged: (value) =>
                      setState(() => _priority = value ?? 'medium'),
                ),
                _radioTile(
                  context,
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
                      child: SketchyButton(
                        onPressed: () {},
                        child: Text('Apply routine', style: typography.label),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SketchyButton(
                        onPressed: () {
                          setState(() {
                            _emailAlerts = true;
                            _smsAlerts = false;
                            _priority = 'medium';
                            _focus = 0.55;
                          });
                        },
                        child: Text('Reset', style: typography.label),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkboxTile(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final typography = SketchyTypography.of(context);
    return Row(
      children: [
        SketchyCheckbox(
          value: value,
          onChanged: (checked) => onChanged(checked ?? value),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: typography.body)),
      ],
    );
  }

  Widget _radioTile(
    BuildContext context, {
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final typography = SketchyTypography.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SketchyRadio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: typography.body)),
        ],
      ),
    );
  }
}
