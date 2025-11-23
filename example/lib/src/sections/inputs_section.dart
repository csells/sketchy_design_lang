import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class InputsSection extends StatefulWidget {
  const InputsSection({super.key});

  @override
  State<InputsSection> createState() => _InputsSectionState();
}

class _InputsSectionState extends State<InputsSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SectionCard(
      title: 'Sketchy input',
      height: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextField with decoration
          TextField(
            controller: _nameController,
            style: bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Hello sketchy input',
              hintStyle: mutedStyle(theme),
              labelStyle: fieldLabelStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            style: bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'User Email',
              hintText: 'Please enter user email',
              hintStyle: mutedStyle(theme),
              labelStyle: fieldLabelStyle(theme),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ageController,
            style: bodyStyle(theme),
            decoration: InputDecoration(
              labelText: 'Your age',
              hintText: 'Your age please!',
              hintStyle: mutedStyle(theme),
              labelStyle: fieldLabelStyle(theme),
            ),
          ),
        ],
      ),
    ),
  );
}
