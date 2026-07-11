import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.blur = 20.0, // Increased blur for better "frosted" separation
    this.opacity = 0.1, // Slightly higher opacity for visibility
    this.borderRadius = 24.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        // OUTER GLOW: Makes the card "float" off the background video
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              // THE TINT: Using a mix of Black and Accent to prevent "Grey Wash"
              color: Color.alphaBlend(
                accentColor.withOpacity(0.03),
                Colors.black.withOpacity(0.4),
              ),

              // THE LIGHT CATCH: Multi-colored border for realism
              border: Border.all(
                color: accentColor.withOpacity(0.25), // Stronger border
                width: 1.5,
              ),

              // THE TEXTURE: Linear gradient simulating a "sheen" across the glass
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12), // High-light corner
                  Colors.transparent,
                  accentColor.withOpacity(0.05), // Mood corner
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
