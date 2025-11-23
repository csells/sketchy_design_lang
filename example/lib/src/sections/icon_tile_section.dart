import 'package:flutter/widgets.dart';
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
      title: 'Symbols & tiles',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // To ensure 2 rows of 5, we can use a ConstrainedBox to limit width
          // if we want to force a break, but Wrap naturally flows.
          // With 11 symbols (plus...x...plus new chevronDown),
          // let's just list them all and use Wrap.
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: SketchySymbols.values
                .map(
                  (symbol) => SketchyTooltip(
                    message: symbol.name,
                    child: SketchyIconButton(
                      icon: SketchySymbol(symbol: symbol),
                      onPressed: () {},
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          SketchyListTile(
            leading: const SketchySymbol(symbol: SketchySymbols.plus),
            title: Text('Brand refresh', style: bodyStyle(theme)),
            subtitle: Text(
              'Rally design + docs for review',
              style: mutedStyle(theme),
            ),
            trailing: SketchyIconButton(
              icon: const SketchySymbol(symbol: SketchySymbols.x),
              onPressed: () {},
              iconSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          SketchyListTile(
            leading: const SketchySymbol(symbol: SketchySymbols.chevronRight),
            title: Text('Follow-up nudges', style: bodyStyle(theme)),
            subtitle: Text(
              'Mute autopings after 10pm',
              style: mutedStyle(theme),
            ),
            trailing: SketchySwitch(
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
