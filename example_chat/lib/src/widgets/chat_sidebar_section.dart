import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// A collapsible section for the chat sidebar.
class ChatSidebarSection extends StatefulWidget {
  /// Creates a chat sidebar section.
  const ChatSidebarSection({
    required this.title,
    required this.children,
    super.key,
    this.initiallyExpanded = true,
  });

  /// The section title.
  final String title;

  /// The children widgets.
  final List<Widget> children;

  /// Whether the section is initially expanded.
  final bool initiallyExpanded;

  @override
  State<ChatSidebarSection> createState() => _ChatSidebarSectionState();
}

class _ChatSidebarSectionState extends State<ChatSidebarSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SketchySymbol(
                    symbol: _isExpanded
                        ? SketchySymbols.chevronDown
                        : SketchySymbols.chevronRight,
                    size: 12,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  SketchyText(
                    widget.title,
                    style: theme.typography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.inkColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded) ...widget.children,
      ],
    ),
  );
}
