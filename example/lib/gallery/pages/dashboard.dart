import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Desktop dashboard combining cards, charts, and list tiles.
class WireframeDashboardExample extends StatelessWidget {
  const WireframeDashboardExample({super.key});

  static Widget builder(BuildContext context) =>
      const WireframeDashboardExample();

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);

    return SketchyScaffold(
      appBar: const SketchyAppBar(
        title: Text('Wireframe Productivity Dashboard'),
        actions: [
          SketchyTooltip(
            message: 'New board',
            child: SketchyIconButton(icon: SketchyIcons.plus),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isWide ? 240 : double.infinity,
                  child: SketchyCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spaces', style: typography.title),
                        const SizedBox(height: 12),
                        ...['Inbox', 'Team board', 'Ideas', 'Archive'].map(
                          (item) => SketchyListTile(
                            title: Text(item),
                            leading: const Text('—'),
                            onTap: () {},
                          ),
                        ),
                        const SketchyDivider(),
                        const SketchyButton.ghost(
                          label: 'Add space',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isWide)
                  const SizedBox(width: 24)
                else
                  const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          const _DashboardCard(
                            title: 'Weekly throughput',
                            child: SizedBox(
                              height: 180,
                              child: RoughChart(data: [12, 16, 10, 20, 14, 18]),
                            ),
                          ),
                          _DashboardCard(
                            title: 'Active flows',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Storyboard revamp',
                                  style: typography.body,
                                ),
                                const SizedBox(height: 4),
                                const SketchyProgressBar(value: 0.62),
                                const SizedBox(height: 12),
                                Text('Billing polish', style: typography.body),
                                const SizedBox(height: 4),
                                const SketchyProgressBar(value: 0.31),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _DashboardCard(
                        title: 'Feed',
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => SketchyListTile(
                              title: Text('Concept draft #$index'),
                              subtitle: const Text('Updated 2m ago'),
                              trailing: const SketchyIconButton(
                                icon: SketchyIcons.chevronRight,
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return SketchyCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Minimal rough-styled line chart used inside the dashboard.
class RoughChart extends StatelessWidget {
  const RoughChart({required this.data, super.key});
  final List<double> data;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ChartPainter(data: data));
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.data});
  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SketchyPalette.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final step = size.width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = step * i;
      final y = size.height - (data[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
