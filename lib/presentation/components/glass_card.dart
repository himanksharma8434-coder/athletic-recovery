import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// GLASS CARD — Reusable Glassmorphic Surface Widget
// Apple Liquid Glass inspired: translucent fill, backdrop blur, specular edge
// highlight, faint outer glow. Single implementation used across all screens.
// ═══════════════════════════════════════════════════════════════════════════════

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? accentGlow;         // Optional neon glow for focal cards
  final bool elevated;             // Use elevated glass fill
  final VoidCallback? onTap;
  final double? width;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Tok.space16),
    this.borderRadius = Tok.radiusMd,
    this.accentGlow,
    this.elevated = false,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = elevated ? Tok.glassFillElevated : Tok.glassFill;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: Tok.glassBlurSigma,
          sigmaY: Tok.glassBlurSigma,
        ),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: fillColor,
            // Specular highlight: brighter border on top edge, standard on others
            border: Border(
              top: BorderSide(
                color: Tok.glassBorderBright,
                width: 0.5,
              ),
              left: BorderSide(
                color: Tok.glassBorder.withValues(alpha: 0.12),
                width: 0.5,
              ),
              right: BorderSide(
                color: Tok.glassBorder.withValues(alpha: 0.08),
                width: 0.5,
              ),
              bottom: BorderSide(
                color: Tok.glassBorder.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
            // Subtle gradient overlay for liquid glass feel
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.01),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
            boxShadow: [
              // Outer glow (faint, replaces Material elevation shadow)
              BoxShadow(
                color: accentGlow ?? Tok.glassGlow,
                blurRadius: accentGlow != null ? 20 : 12,
                spreadRadius: accentGlow != null ? 1 : 0,
              ),
              // Soft dark shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

/// Lighter-weight glass card (less blur, less overhead) for items inside lists
/// or for secondary surfaces that don't need the full glass treatment.
class GlassCardLight extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassCardLight({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Tok.space12),
    this.borderRadius = Tok.radiusSm,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: Tok.glassBlurSigmaLight,
          sigmaY: Tok.glassBlurSigmaLight,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Tok.glassFillRecessed,
            border: Border.all(
              color: Tok.glassBorder.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

/// Glass Pill — for status badges, tags, and filter chips.
class GlassPill extends StatelessWidget {
  final Widget child;
  final Color? accentColor;
  final EdgeInsetsGeometry padding;

  const GlassPill({
    super.key,
    required this.child,
    this.accentColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: accentColor?.withValues(alpha: 0.12) ?? Tok.glassFillRecessed,
        borderRadius: BorderRadius.circular(Tok.radiusFull),
        border: Border.all(
          color: accentColor?.withValues(alpha: 0.25) ??
              Tok.glassBorder.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
