import 'package:flutter/material.dart';

/// Kinetic Obsidian Color System
/// Calibrated luminance model designed for dark, high-contrast athletic telemetry.
class RecovaColors {
  RecovaColors._();

  // ── Surface Architecture ──────────────────────────────────────────
  static const Color canvasBase = Color(0xFF08090C); // Absolute deep field
  static const Color surfaceElevation1 = Color(0xFF111318); // Cards
  static const Color surfaceElevation2 = Color(0xFF0B0D11); // Recessed insets
  static const Color surfaceElevation3 = Color(0xFF181B22); // Floating bars / nav
  static const Color surfaceContainer = Color(0xFF1F1F23);
  static const Color surfaceContainerHigh = Color(0xFF292A2D);
  static const Color surfaceContainerHighest = Color(0xFF343538);

  // ── Structural Borders ────────────────────────────────────────────
  static const Color borderSubtle = Color(0x14FFFFFF); // 8% white
  static const Color borderMedium = Color(0x1FFFFFFF); // 12% white
  static const Color borderHover = Color(0x33FFFFFF); // 20% white
  static const Color surfaceOverlay = Color(0x0AFFFFFF); // 4% white

  // ── Typography Colors ─────────────────────────────────────────────
  static const Color onSurface = Color(0xFFE3E2E6);
  static const Color onSurfaceVariant = Color(0xFFBACBBC);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textTertiary = Color(0x80FFFFFF); // 50% white
  static const Color textMuted = Color(0x59FFFFFF); // 35% white

  // ── Recovery Emerald (Primary) ────────────────────────────────────
  static const Color recoveryEmerald = Color(0xFF00F090);
  static const Color recoveryEmeraldBright = Color(0xFF58FFA5);
  static const Color recoveryEmeraldDim = Color(0xFF00E388);
  static const Color recoveryEmeraldContainer = Color(0x1F00F090); // 12% alpha
  static const Color recoveryEmeraldBorder = Color(0x4D00F090); // 30% alpha

  // ── Restorative Azure (Sleep/Secondary) ───────────────────────────
  static const Color restorativeAzure = Color(0xFF00D2FF);
  static const Color restorativeAzureBright = Color(0xFFA5E7FF);
  static const Color restorativeAzureSky = Color(0xFF38BDF8);
  static const Color restorativeAzureContainer = Color(0x1F00D2FF);
  static const Color restorativeAzureBorder = Color(0x4D00D2FF);

  // ── Kinetic Amber (Strain/Workouts) ───────────────────────────────
  static const Color kineticAmber = Color(0xFFFF6B00);
  static const Color kineticAmberGold = Color(0xFFFF9E00);
  static const Color kineticAmberLight = Color(0xFFFFB84D);
  static const Color kineticAmberContainer = Color(0x1FFF6B00);
  static const Color kineticAmberBorder = Color(0x4DFF6B00);

  // ── Stress Crimson (Suppressed State) ─────────────────────────────
  static const Color stressCrimson = Color(0xFFFF3B56);
  static const Color stressCrimsonContainer = Color(0x1FFF3B56);
  static const Color stressCrimsonBorder = Color(0x4DFF3B56);

  // ── Neural Violet (REM/Predictive) ────────────────────────────────
  static const Color neuralViolet = Color(0xFF8B5CF6);
  static const Color neuralVioletContainer = Color(0x1F8B5CF6);
  static const Color neuralVioletBorder = Color(0x4D8B5CF6);

  // ── Glow Effects ──────────────────────────────────────────────────
  static const Color glowRecovery = Color(0x4700F090);
  static const Color glowStrain = Color(0x3DFF6B00);
  static const Color glowSleep = Color(0x3800D2FF);
}

/// Recovery score tier classification
enum RecoveryTier {
  optimal('OPTIMAL RECOVERY', 'PRIMED FOR STRAIN', RecovaColors.recoveryEmerald,
      RecovaColors.recoveryEmeraldContainer, RecovaColors.recoveryEmeraldBorder),
  moderate('MODERATE RECOVERY', 'MAINTAIN LOAD', RecovaColors.kineticAmberGold,
      RecovaColors.kineticAmberContainer, RecovaColors.kineticAmberBorder),
  suppressed('SUPPRESSED RECOVERY', 'ACTIVE REST RECOMMENDED',
      RecovaColors.stressCrimson, RecovaColors.stressCrimsonContainer,
      RecovaColors.stressCrimsonBorder),
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
