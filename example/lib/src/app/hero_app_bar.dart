import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

class HeroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeroAppBar({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => AppBar(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.all(16),
      leading: Tooltip(
        message: 'meh.',
        preferBelow: true,
        child: SketchyFrame(
          child: SizedBox(
            width: 96,
            height: 96,
            child: Center(
              child: Image.asset(
                'assets/images/sketchy_mascot.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sketchy',
            style: theme.typography.headline.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text('''
A hand-drawn, xkcd-inspired design language for Flutter on mobile, desktop, and
web powered by the wired_elements code, the flutter_rough package and the
Comic Shanns font.
''', style: theme.typography.title.copyWith(fontSize: 14)),
        ],
      ),
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(140); // Approximate height
}
