import 'package:flutter/material.dart';

/// Nothing X Minimalist Monochrome Color System
/// High-contrast black & white telemetry with surgical Nothing Red accents.
class RecovaColors {
  RecovaColors._();

  // ── Surface Architecture (Nothing Pure OLED Dark) ───────────────────
  static const Color canvasBase = Color(0xFF08090C); // Pitch OLED black
  static const Color surfaceElevation1 = Color(0xFF111215); // Carbon card
  static const Color surfaceElevation2 = Color(0xFF0B0C0E); // Recessed insets
  static const Color surfaceElevation3 = Color(0xFF16171B); // Floating bars / nav
  static const Color surfaceContainer = Color(0xFF18191D);
  static const Color surfaceContainerHigh = Color(0xFF222327);
  static const Color surfaceContainerHighest = Color(0xFF2C2D32);

  // ── Structural Hairline Borders ───────────────────────────────────
  static const Color borderSubtle = Color(0x14FFFFFF); // 8% white hairline
  static const Color borderMedium = Color(0x24FFFFFF); // 14% white
  static const Color borderHover = Color(0x40FFFFFF); // 25% white
  static const Color surfaceOverlay = Color(0x0AFFFFFF); // 4% white

  // ── High-Contrast Typography ──────────────────────────────────────
  static const Color onSurface = Color(0xFFEEEEEE);
  static const Color onSurfaceVariant = Color(0xFFAAAAAA);
  static const Color textPrimary = Color(0xFFFFFFFF); // Stark pure white
  static const Color textSecondary = Color(0xFFB0B0B0); // Cool silver
  static const Color textTertiary = Color(0xFF757575); // Mid gray
  static const Color textMuted = Color(0xFF4A4A4A); // Muted dark gray

  // ── Nothing Signature Red (Surgical Live & Alert Accent) ──────────
  static const Color nothingRed = Color(0xFFD71920); // Signature Nothing Red
  static const Color nothingRedContainer = Color(0x26D71920);
  static const Color nothingRedBorder = Color(0x4DD71920);

  // ── Monochrome Telemetry Scales (Replaces Neon Gradients) ─────────
  static const Color monochromeWhite = Color(0xFFFFFFFF);
  static const Color monochromeSilver = Color(0xFFD6D6D6);
  static const Color monochromeGray = Color(0xFF8E8E93);
  static const Color monochromeDark = Color(0xFF2C2C2E);

  // ── Backwards-Compatible Semantic Tokens (Mapped to B&W + Red) ─────
  // Primary / Recovery (Crisp Stark White)
  static const Color recoveryEmerald = Color(0xFFFFFFFF);
  static const Color recoveryEmeraldBright = Color(0xFFFFFFFF);
  static const Color recoveryEmeraldDim = Color(0xFFCCCCCC);
  static const Color recoveryEmeraldContainer = Color(0x14FFFFFF);
  static const Color recoveryEmeraldBorder = Color(0x33FFFFFF);

  // Sleep / Restorative (Muted Clean Silver)
  static const Color restorativeAzure = Color(0xFFE0E0E0);
  static const Color restorativeAzureBright = Color(0xFFFFFFFF);
  static const Color restorativeAzureSky = Color(0xFFCCCCCC);
  static const Color restorativeAzureContainer = Color(0x14FFFFFF);
  static const Color restorativeAzureBorder = Color(0x2BFFFFFF);

  // Strain / Workouts (Tactile Cool Silver)
  static const Color kineticAmber = Color(0xFFD4D4D4);
  static const Color kineticAmberGold = Color(0xFFE8E8E8);
  static const Color kineticAmberLight = Color(0xFFFFFFFF);
  static const Color kineticAmberContainer = Color(0x14FFFFFF);
  static const Color kineticAmberBorder = Color(0x2BFFFFFF);

  // Suppressed / Warning (Nothing Red)
  static const Color stressCrimson = Color(0xFFD71920);
  static const Color stressCrimsonContainer = Color(0x26D71920);
  static const Color stressCrimsonBorder = Color(0x4DD71920);

  // Secondary / Predictive (Muted Neutral)
  static const Color neuralViolet = Color(0xFFB8B8B8);
  static const Color neuralVioletContainer = Color(0x14FFFFFF);
  static const Color neuralVioletBorder = Color(0x26FFFFFF);

  // ── Sub-pixel Ambient Layering (Clean, No Loud Neons) ─────────────
  static const Color glowRecovery = Color(0x0DFFFFFF);
  static const Color glowStrain = Color(0x0DFFFFFF);
  static const Color glowSleep = Color(0x0DFFFFFF);
}

/// Recovery score tier classification (Nothing X High-Contrast Monochrome)
enum RecoveryTier {
  optimal('OPTIMAL RECOVERY', 'PRIMED FOR STRAIN', RecovaColors.monochromeWhite,
      RecovaColors.surfaceOverlay, RecovaColors.borderMedium),
  moderate('MODERATE RECOVERY', 'MAINTAIN LOAD', RecovaColors.monochromeSilver,
      RecovaColors.surfaceOverlay, RecovaColors.borderSubtle),
  suppressed('SUPPRESSED RECOVERY', 'ACTIVE REST RECOMMENDED',
      RecovaColors.nothingRed, RecovaColors.nothingRedContainer,
      RecovaColors.nothingRedBorder),
  calibrating('CALIBRATING', 'SYNCING BIOMETRICS', RecovaColors.textTertiary,
      RecovaColors.surfaceOverlay, RecovaColors.borderSubtle);

  final String label;
  final String statusSubtitle;
  final Color color;
  final Color containerColor;
  final Color borderColor;

  const RecoveryTier(this.label, this.statusSubtitle, this.color,
      this.containerColor, this.borderColor);

  static RecoveryTier fromScore(double? score) {
    if (score == null || score <= 0) return RecoveryTier.calibrating;
    if (score <= 33) return RecoveryTier.suppressed;
    if (score <= 66) return RecoveryTier.moderate;
    return RecoveryTier.optimal;
  }
}
