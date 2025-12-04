import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_colors.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';
import 'sketchy_text.dart';

/// A circular avatar widget with sketchy styling.
///
/// Supports images, initials fallback, online status indicator, and badges.
class SketchyAvatar extends StatefulWidget {
  /// Creates a sketchy avatar.
  const SketchyAvatar({
    super.key,
    this.imageProvider,
    this.initials,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.badge,
  });

  /// Optional image to display.
  final ImageProvider? imageProvider;

  /// Initials to show when no image is provided.
  final String? initials;

  /// Radius of the avatar circle.
  final double radius;

  /// Background color (defaults to theme secondary color).
  final Color? backgroundColor;

  /// Foreground/text color (defaults to theme ink color).
  final Color? foregroundColor;

  /// Whether to show the online status indicator.
  final bool showOnlineIndicator;

  /// Whether the user is online (only used if [showOnlineIndicator] is true).
  final bool isOnline;

  /// Optional badge widget to display (e.g., AI badge).
  final Widget? badge;

  @override
  State<SketchyAvatar> createState() => _SketchyAvatarState();
}

class _SketchyAvatarState extends State<SketchyAvatar> {
  late final SketchyPrimitive _circlePrimitive;
  late final SketchyPrimitive _indicatorPrimitive;

  @override
  void initState() {
    super.initState();
    _circlePrimitive = SketchyPrimitive.circle(fill: SketchyFill.solid);
    _indicatorPrimitive = SketchyPrimitive.circle(fill: SketchyFill.solid);
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final size = widget.radius * 2;
      final bgColor = widget.backgroundColor ?? theme.secondaryColor;
      final fgColor = widget.foregroundColor ?? theme.inkColor;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: SketchySurface(
              fillColor: bgColor,
              strokeColor: theme.inkColor,
              createPrimitive: () => _circlePrimitive,
              child: widget.imageProvider != null
                  ? ClipOval(
                      child: Image(
                        image: widget.imageProvider!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) =>
                            _buildInitialsContent(theme, fgColor),
                      ),
                    )
                  : _buildInitialsContent(theme, fgColor),
            ),
          ),
          if (widget.showOnlineIndicator && widget.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: size * 0.3,
                height: size * 0.3,
                child: SketchySurface(
                  fillColor: SketchyColors.onlineGreen,
                  strokeColor: theme.paperColor,
                  strokeWidth: 1.5,
                  createPrimitive: () => _indicatorPrimitive,
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          if (widget.badge != null)
            Positioned(right: -4, top: -4, child: widget.badge!),
        ],
      );
    },
  );

  Widget _buildInitialsContent(SketchyThemeData theme, Color fgColor) => Center(
    child: SketchyText(
      widget.initials ?? '?',
      style: theme.typography.body.copyWith(
        color: fgColor,
        fontWeight: FontWeight.w600,
        fontSize: widget.radius * 0.8,
      ),
    ),
  );
}
