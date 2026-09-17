package com.recova.app.ui.theme

import androidx.compose.ui.graphics.Color

/**
 * Kinetic Obsidian Color System
 *
 * A calibrated luminance model where semantic state dictates visual dominance.
 * Designed for OLED displays — deep blacks maximize battery and create
 * a borderless visual experience.
 */
object RecovaColors {

    // ── Surface Architecture ──────────────────────────────────────────
    val canvasBase = Color(0xFF08090C)          // Absolute deep field
    val surfaceElevation1 = Color(0xFF111318)   // Cards (low-reflectance midnight alloy)
    val surfaceElevation2 = Color(0xFF0B0D11)   // Recessed inset surfaces
    val surfaceElevation3 = Color(0xFF181B22)   // Floating bars / dialogs
    val surfaceContainer = Color(0xFF1F1F23)
    val surfaceContainerHigh = Color(0xFF292A2D)
    val surfaceContainerHighest = Color(0xFF343538)

    // ── Structural Borders ────────────────────────────────────────────
    val borderSubtle = Color(0x14FFFFFF)         // 8% white
    val borderMedium = Color(0x1FFFFFFF)         // 12% white
    val borderHover = Color(0x33FFFFFF)          // 20% white
    val surfaceOverlay = Color(0x0AFFFFFF)       // 4% white (interactive states)

    // ── On-Surface Text ───────────────────────────────────────────────
    val onSurface = Color(0xFFE3E2E6)
    val onSurfaceVariant = Color(0xFFBACBBC)
    val textPrimary = Color(0xFFFFFFFF)
    val textSecondary = Color(0xB3FFFFFF)        // 70% white
    val textTertiary = Color(0x80FFFFFF)         // 50% white
    val textQuaternary = Color(0x66FFFFFF)       // 40% white
    val textMuted = Color(0x59FFFFFF)            // 35% white

    // ── Recovery Emerald (Primary) ────────────────────────────────────
    // Readiness scores 67–100%, optimal autonomic state
    val recoveryEmerald = Color(0xFF00F090)
    val recoveryEmeraldBright = Color(0xFF58FFA5)
    val recoveryEmeraldDim = Color(0xFF00E388)
    val recoveryEmeraldSubtle = Color(0xFF10B981)
    val recoveryEmeraldContainer = Color(0x1F00F090)  // 12% alpha
    val recoveryEmeraldBorder = Color(0x4D00F090)     // 30% alpha

    // ── Restorative Azure (Sleep/Recovery secondary) ──────────────────
    // Sleep cycles, parasympathetic states, baseline
    val restorativeAzure = Color(0xFF00D2FF)
    val restorativeAzureBright = Color(0xFFA5E7FF)
    val restorativeAzureSky = Color(0xFF38BDF8)
    val restorativeAzureContainer = Color(0x1F00D2FF)
    val restorativeAzureBorder = Color(0x4D00D2FF)

    // ── Kinetic Amber (Strain/Activity) ───────────────────────────────
    // Strain accumulation, HR zones 3–5, caloric load
    val kineticAmber = Color(0xFFFF6B00)
    val kineticAmberGold = Color(0xFFFF9E00)
    val kineticAmberWarm = Color(0xFFF59E0B)
    val kineticAmberLight = Color(0xFFFFB84D)
    val kineticAmberContainer = Color(0x1FFF6B00)
    val kineticAmberBorder = Color(0x4DFF6B00)

    // ── Stress Crimson (Low recovery/alert) ───────────────────────────
    // Recovery <33%, acute exhaustion, ANS duress
    val stressCrimson = Color(0xFFFF3B56)
    val stressCrimsonContainer = Color(0x1FFF3B56)
    val stressCrimsonBorder = Color(0x4DFF3B56)

    // ── Neural Violet (REM/Predictive) ────────────────────────────────
    // REM sleep, predictive algorithms, synthetic biomarkers
    val neuralViolet = Color(0xFF8B5CF6)
    val neuralVioletContainer = Color(0x1F8B5CF6)
    val neuralVioletBorder = Color(0x4D8B5CF6)

    // ── Semantic State Colors ─────────────────────────────────────────
    val optimal = recoveryEmerald
    val moderate = kineticAmber
    val suppressed = stressCrimson

    // ── Material 3 Bridge Colors ──────────────────────────────────────
    val primary = Color(0xFFB4FFCB)
    val onPrimary = Color(0xFF00391E)
    val primaryContainer = recoveryEmerald
    val secondary = restorativeAzureBright
    val tertiary = Color(0xFFFFEAE1)
    val error = Color(0xFFFFB4AB)
    val errorContainer = Color(0xFF93000A)

    // ── Glow Effects ──────────────────────────────────────────────────
    val glowRecovery = Color(0x4700F090)      // 28% alpha green glow
    val glowStrain = Color(0x3DFF6B00)        // 24% alpha orange glow
    val glowSleep = Color(0x3800D2FF)         // 22% alpha cyan glow
}

/**
 * Recovery score tier classification
 */
enum class RecoveryTier(val label: String, val color: Color, val containerColor: Color, val borderColor: Color) {
    OPTIMAL("Optimal Recovery", RecovaColors.recoveryEmerald, RecovaColors.recoveryEmeraldContainer, RecovaColors.recoveryEmeraldBorder),
    MODERATE("Moderate Recovery", RecovaColors.kineticAmberGold, RecovaColors.kineticAmberContainer, RecovaColors.kineticAmberBorder),
    SUPPRESSED("Low Recovery", RecovaColors.stressCrimson, RecovaColors.stressCrimsonContainer, RecovaColors.stressCrimsonBorder),
    CALIBRATING("Calibrating", RecovaColors.textTertiary, RecovaColors.surfaceOverlay, RecovaColors.borderSubtle);

    companion object {
        fun fromScore(score: Int): RecoveryTier = when {
            score < 0 -> CALIBRATING
            score <= 33 -> SUPPRESSED
            score <= 66 -> MODERATE
            else -> OPTIMAL
        }
    }
}
