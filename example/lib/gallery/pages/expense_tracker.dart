import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Form screen covering text fields, dropdowns, switches, and validation.
class ExpenseTrackerExample extends StatefulWidget {
  const ExpenseTrackerExample({super.key});

  static Widget builder(BuildContext context) => const ExpenseTrackerExample();

  @override
  State<ExpenseTrackerExample> createState() => _ExpenseTrackerExampleState();
}

class _ExpenseTrackerExampleState extends State<ExpenseTrackerExample> {
  final _amountController = TextEditingController(text: '128.00');
  final _noteController = TextEditingController(text: 'Client kickoff snacks');
  bool _recurring = false;
  String _category = 'Meals';

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);

    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Expense Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SketchyCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New expense', style: typography.headline),
              const SizedBox(height: 16),
              SketchyAnnotate.underline(
                label: 'Validation example',
                child: SketchyTextField(
                  label: r'Amount ($)',
                  controller: _amountController,
                  onChanged: (value) => setState(() {}),
                  errorText: _amountController.text.isEmpty
                      ? 'Amount required'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SketchyTextField(
                label: 'Notes',
                controller: _noteController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SketchyDropdown<String>(
                label: 'Category',
                value: _category,
                items: const ['Meals', 'Travel', 'Supplies'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SketchySwitchTile(
                label: 'Mark as recurring',
                value: _recurring,
                onChanged: (value) => setState(() => _recurring = value),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SketchyButton.primary(
                      label: 'Submit expense',
                      onPressed: _amountController.text.isEmpty ? null : () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SketchyButton.secondary(
                      label: 'Save draft',
                      onPressed: () {},
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
