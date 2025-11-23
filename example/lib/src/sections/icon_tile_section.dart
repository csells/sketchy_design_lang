import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class IconTileSection extends StatefulWidget {
  const IconTileSection({super.key});

  @override
  State<IconTileSection> createState() => _IconTileSectionState();
}

class _IconTileSectionState extends State<IconTileSection> {
  bool _followUpsEnabled = true;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Icons & tiles',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.plus),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.pen),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.pen),
            title: Text('Brand refresh', style: bodyStyle(theme)),
            subtitle: Text(
              'Rally design + docs for review',
              style: mutedStyle(theme),
            ),
            trailing: IconButton(
              icon: const FaIcon(FontAwesomeIcons.check),
              onPressed: () {},
              iconSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.copy),
            title: Text('Follow-up nudges', style: bodyStyle(theme)),
            subtitle: Text(
              'Mute autopings after 10pm',
              style: mutedStyle(theme),
            ),
            trailing: Switch(
              value: _followUpsEnabled,
              onChanged: (value) => setState(() {
                _followUpsEnabled = value;
              }),
            ),
          ),
        ],
      ),
    ),
  );
}
