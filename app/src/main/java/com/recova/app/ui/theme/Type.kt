package com.recova.app.ui.theme

import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.googlefonts.Font
import androidx.compose.ui.text.googlefonts.GoogleFont
import androidx.compose.ui.unit.sp

/**
 * Kinetic Obsidian Typography System
 *
 * Three-family hierarchy:
 * - Space Grotesk: Performance scores & hero metrics
 * - JetBrains Mono: Biometric telemetry & timestamps
 * - Inter: Body text, headers, descriptions
 */

private val fontProvider = GoogleFont.Provider(
    providerAuthority = "com.google.android.gms.fonts",
    providerPackage = "com.google.android.gms",
    certificates = com.recova.app.R.array.com_google_android_gms_fonts_certs
)

private val SpaceGrotesk = FontFamily(
    Font(
        googleFont = GoogleFont("Space Grotesk"),
        fontProvider = fontProvider,
        weight = FontWeight.Bold
    ),
    Font(
        googleFont = GoogleFont("Space Grotesk"),
        fontProvider = fontProvider,
        weight = FontWeight.SemiBold
    ),
    Font(
        googleFont = GoogleFont("Space Grotesk"),
        fontProvider = fontProvider,
        weight = FontWeight.Normal
    ),
    Font(
        googleFont = GoogleFont("Space Grotesk"),
        fontProvider = fontProvider,
        weight = FontWeight.Light
    )
)

private val JetBrainsMono = FontFamily(
    Font(
        googleFont = GoogleFont("JetBrains Mono"),
        fontProvider = fontProvider,
        weight = FontWeight.Bold
    ),
    Font(
        googleFont = GoogleFont("JetBrains Mono"),
        fontProvider = fontProvider,
        weight = FontWeight.SemiBold
    ),
    Font(
        googleFont = GoogleFont("JetBrains Mono"),
        fontProvider = fontProvider,
        weight = FontWeight.Medium
    ),
    Font(
        googleFont = GoogleFont("JetBrains Mono"),
        fontProvider = fontProvider,
        weight = FontWeight.Normal
    )
)

private val Inter = FontFamily(
    Font(
        googleFont = GoogleFont("Inter"),
        fontProvider = fontProvider,
        weight = FontWeight.Bold
    ),
    Font(
        googleFont = GoogleFont("Inter"),
        fontProvider = fontProvider,
        weight = FontWeight.SemiBold
    ),
    Font(
        googleFont = GoogleFont("Inter"),
        fontProvider = fontProvider,
        weight = FontWeight.Medium
    ),
    Font(
        googleFont = GoogleFont("Inter"),
        fontProvider = fontProvider,
        weight = FontWeight.Normal
    )
)

/**
 * Complete typography scale following Kinetic Obsidian specification
 */
object RecovaTypography {

    // ── Display / Hero Scores ─────────────────────────────────────────
    val displayHero = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 56.sp,
        fontWeight = FontWeight.Bold,
        lineHeight = 60.sp,
        letterSpacing = (-0.04).sp * 56  // -0.04em
    )

    val displayHeroMobile = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 44.sp,
        fontWeight = FontWeight.Bold,
        lineHeight = 48.sp,
        letterSpacing = (-0.03).sp * 44
    )

    // Score display — used inside radial gauges (52px as shown in reference)
    val scoreDisplay = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 52.sp,
        fontWeight = FontWeight.Light,
        lineHeight = 52.sp,
        letterSpacing = (-0.02).sp * 52
    )

    // ── Headline / Metric Values ──────────────────────────────────────
    val headlineMetric = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 36.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 40.sp,
        letterSpacing = (-0.02).sp * 36
    )

    val headlineMetricMobile = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 30.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 34.sp,
        letterSpacing = (-0.02).sp * 30
    )

    // Card metric values (26px as in bento pods)
    val metricValue = TextStyle(
        fontFamily = SpaceGrotesk,
        fontSize = 26.sp,
        fontWeight = FontWeight.Light,
        lineHeight = 26.sp,
        letterSpacing = (-0.02).sp * 26
    )

    val headlineLg = TextStyle(
        fontFamily = Inter,
        fontSize = 24.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 30.sp,
        letterSpacing = (-0.015).sp * 24
    )

    val headlineMd = TextStyle(
        fontFamily = Inter,
        fontSize = 20.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 26.sp,
        letterSpacing = (-0.01).sp * 20
    )

    val headlineSm = TextStyle(
        fontFamily = Inter,
        fontSize = 16.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 22.sp,
        letterSpacing = 0.sp
    )

    // ── Body Text ─────────────────────────────────────────────────────
    val bodyLg = TextStyle(
        fontFamily = Inter,
        fontSize = 15.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 22.sp,
        letterSpacing = 0.sp
    )

    val bodyMd = TextStyle(
        fontFamily = Inter,
        fontSize = 13.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 18.sp,
        letterSpacing = 0.065.sp  // 0.005em × 13
    )

    val bodySm = TextStyle(
        fontFamily = Inter,
        fontSize = 12.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 16.sp,
        letterSpacing = 0.12.sp   // 0.01em × 12
    )

    // ── Telemetry Labels (Monospaced) ─────────────────────────────────
    val labelData = TextStyle(
        fontFamily = JetBrainsMono,
        fontSize = 13.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 16.sp,
        letterSpacing = 0.26.sp   // 0.02em × 13
    )

    val labelCaps = TextStyle(
        fontFamily = JetBrainsMono,
        fontSize = 10.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 14.sp,
        letterSpacing = 0.8.sp    // 0.08em × 10
    )

    // Smaller tactical caps (9px as used in reference designs)
    val labelCapsSm = TextStyle(
        fontFamily = JetBrainsMono,
        fontSize = 9.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 12.sp,
        letterSpacing = 1.08.sp   // 0.12em × 9
    )

    // Even smaller (8px for fine detail)
    val labelCapsXs = TextStyle(
        fontFamily = JetBrainsMono,
        fontSize = 8.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 10.sp,
        letterSpacing = 0.64.sp
    )

    val labelSm = TextStyle(
        fontFamily = Inter,
        fontSize = 11.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 14.sp,
        letterSpacing = 0.11.sp
    )

    // Inline data values (15px in telemetry rows)
    val dataValue = TextStyle(
        fontFamily = JetBrainsMono,
        fontSize = 15.sp,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 18.sp,
        letterSpacing = (-0.01).sp * 15
    )
}
