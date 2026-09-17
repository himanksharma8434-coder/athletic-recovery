package com.recova.app.ui.theme

import androidx.compose.ui.unit.dp

/**
 * Kinetic Obsidian Spacing System
 *
 * Anchored to a strict 4px sub-grid.
 * Padding inside data cards follows an asymmetric formula:
 * vertical space-md (12px) and horizontal space-lg (16px).
 */
object RecovaSpacing {
    val space2xs = 2.dp     // 0.125rem
    val spaceXs = 4.dp      // 0.25rem
    val spaceSm = 8.dp      // 0.5rem
    val spaceMd = 12.dp     // 0.75rem
    val spaceLg = 16.dp     // 1rem
    val spaceXl = 24.dp     // 1.5rem
    val space2xl = 32.dp    // 2rem

    val gutter = 12.dp      // Grid gutter
    val gutterCompact = 8.dp
    val margin = 16.dp      // Screen margin
    val marginSm = 12.dp

    // Card padding (asymmetric)
    val cardPaddingVertical = spaceMd     // 12dp
    val cardPaddingHorizontal = spaceLg   // 16dp

    // Bottom navigation clearance
    val navBarClearance = 36.dp   // 2.25rem thumb zone safety
}
