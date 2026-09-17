package com.recova.app.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf

/**
 * Kinetic Obsidian Theme
 *
 * Dark-only theme expressing high-performance biometric mastery.
 * Provides access to the custom color system, typography, shapes, and spacing
 * through RecovaTheme.colors, RecovaTheme.typography, etc.
 */

// Material 3 dark color scheme (bridge to M3 components)
private val DarkColorScheme = darkColorScheme(
    primary = RecovaColors.primary,
    onPrimary = RecovaColors.onPrimary,
    primaryContainer = RecovaColors.primaryContainer,
    secondary = RecovaColors.secondary,
    tertiary = RecovaColors.tertiary,
    background = RecovaColors.canvasBase,
    surface = RecovaColors.surfaceElevation1,
    surfaceVariant = RecovaColors.surfaceContainerHigh,
    onBackground = RecovaColors.onSurface,
    onSurface = RecovaColors.onSurface,
    onSurfaceVariant = RecovaColors.onSurfaceVariant,
    error = RecovaColors.error,
    errorContainer = RecovaColors.errorContainer,
    outline = RecovaColors.borderMedium,
    outlineVariant = RecovaColors.borderSubtle,
)

// Composition locals for custom design tokens
private val LocalRecovaColors = staticCompositionLocalOf { RecovaColors }
private val LocalRecovaTypography = staticCompositionLocalOf { RecovaTypography }
private val LocalRecovaShapes = staticCompositionLocalOf { RecovaShapes }
private val LocalRecovaSpacing = staticCompositionLocalOf { RecovaSpacing }

@Composable
fun RecovaTheme(
    content: @Composable () -> Unit
) {
    CompositionLocalProvider(
        LocalRecovaColors provides RecovaColors,
        LocalRecovaTypography provides RecovaTypography,
        LocalRecovaShapes provides RecovaShapes,
        LocalRecovaSpacing provides RecovaSpacing,
    ) {
        MaterialTheme(
            colorScheme = DarkColorScheme,
            content = content
        )
    }
}

/**
 * Access point for Kinetic Obsidian design tokens.
 *
 * Usage:
 *   RecovaTheme.colors.recoveryEmerald
 *   RecovaTheme.typography.scoreDisplay
 *   RecovaTheme.shapes.card
 *   RecovaTheme.spacing.spaceLg
 */
object RecovaTheme {
    val colors: RecovaColors
        @Composable
        @ReadOnlyComposable
        get() = LocalRecovaColors.current

    val typography: RecovaTypography
        @Composable
        @ReadOnlyComposable
        get() = LocalRecovaTypography.current

    val shapes: RecovaShapes
        @Composable
        @ReadOnlyComposable
        get() = LocalRecovaShapes.current

    val spacing: RecovaSpacing
        @Composable
        @ReadOnlyComposable
        get() = LocalRecovaSpacing.current
}
