import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';

/// Settings drawer content for user profile settings.
class SettingsDrawer extends StatefulWidget {
  /// Creates a settings drawer.
  const SettingsDrawer({
    required this.currentUser,
    required this.onUserUpdated,
    required this.onClose,
    super.key,
  });

  /// The current user.
  final ChatParticipant currentUser;

  /// Callback when the user is updated.
  final ValueChanged<ChatParticipant> onUserUpdated;

  /// Callback to close the drawer.
  final VoidCallback onClose;

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late bool _isOnline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _roleController = TextEditingController(
      text: widget.currentUser.role ?? '',
    );
    _isOnline = widget.currentUser.isOnline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updated = widget.currentUser.copyWith(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : widget.currentUser.name,
      role: _roleController.text.trim().isNotEmpty
          ? _roleController.text.trim()
          : null,
      isOnline: _isOnline,
    );
    widget.onUserUpdated(updated);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SketchyText(
                    'Settings',
                    style: theme.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.inkColor,
                    ),
                  ),
                ),
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.x,
                    size: 16,
                    color: theme.inkColor,
                  ),
                  onPressed: widget.onClose,
                  iconSize: 32,
                ),
              ],
            ),
          ),
          const SketchyDivider(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  SketchyText(
                    'Profile',
                    style: theme.typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.inkColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Avatar preview
                  Center(
                    child: SketchyAvatar(
                      initials: _getInitials(),
                      radius: 40,
                      showOnlineIndicator: true,
                      isOnline: _isOnline,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  SketchyTextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // Role field
                  SketchyTextField(
                    controller: _roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 24),

                  // Online status
                  Row(
                    children: [
                      Expanded(
                        child: SketchyText(
                          'Online Status',
                          style: theme.typography.body.copyWith(
                            color: theme.inkColor,
                          ),
                        ),
                      ),
                      SketchySwitch(
                        value: _isOnline,
                        onChanged: (value) => setState(() => _isOnline = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SketchyText(
                    _isOnline
                        ? 'You appear online to others'
                        : 'You appear offline',
                    style: theme.typography.caption.copyWith(
                      color: theme.inkColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
          const SketchyDivider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: SketchyButton(
                onPressed: _saveChanges,
                child: SketchyText(
                  'Save Changes',
                  style: theme.typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.inkColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  String _getInitials() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}
