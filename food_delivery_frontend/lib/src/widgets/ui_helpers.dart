import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
/// GlassCard: Rounded, subtle glassmorphic container using blur-like effect via opacity and shadow.
/// Use for main surfaces to give a premium food app feel.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: scheme.surface.withAlpha(220),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // Soft elevated and embossed shadows (neumorphic hint)
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: scheme.primary.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: scheme.primary.withAlpha(18), width: 0.5),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// PUBLIC_INTERFACE
/// AnimatedTap: Adds a gentle scale animation on tap to any child.
/// Great for buttons and tappable cards to add micro-interactions.
class AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scale;

  const AnimatedTap({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 120),
    this.scale = 0.96,
  });

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap> with SingleTickerProviderStateMixin {
  bool _down = false;

  void _setDown(bool v) {
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setDown(true),
      onTapCancel: () => _setDown(false),
      onTapUp: (_) => _setDown(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// PUBLIC_INTERFACE
/// FoodImage: Shows network image with a fixed aspect ratio and rounded corners,
/// ensuring high-quality consistent visuals. Adds shimmer-like loading via
/// animated container and a subtle placeholder color.
class FoodImage extends StatelessWidget {
  final String url;
  final double borderRadius;
  final double aspectRatio; // e.g., 16/9 for banners, 1 for square thumbs
  final BoxFit fit;

  const FoodImage({
    super.key,
    required this.url,
    this.borderRadius = 12,
    this.aspectRatio = 16 / 9,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          url,
          fit: fit,
          // Basic loading/placeholder handling without extra deps
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            final t = (progress.expectedTotalBytes != null && progress.expectedTotalBytes != 0)
                ? (progress.cumulativeBytesLoaded / (progress.expectedTotalBytes!))
                : null;
            return Stack(
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  color: scheme.primary.withAlpha(20),
                ),
                if (t != null)
                  Center(
                    child: SizedBox(
                      width: 48,
                      child: LinearProgressIndicator(
                        value: t.clamp(0.0, 1.0),
                        color: scheme.tertiary,
                        backgroundColor: scheme.tertiary.withAlpha(40),
                        minHeight: 4,
                      ),
                    ),
                  )
                else
                  Center(
                    child: CircularProgressIndicator(
                      color: scheme.tertiary,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: scheme.error.withAlpha(20),
            alignment: Alignment.center,
            child: Icon(Icons.broken_image, color: scheme.error),
          ),
        ),
      ),
    );
  }
}
