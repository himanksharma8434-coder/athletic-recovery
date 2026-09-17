package com.recova.app.ui.theme

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.unit.dp

/**
 * Kinetic Obsidian Shape System
 *
 * Ergonomic geometry balancing hand-feel with structural engineering aesthetics.
 */
object RecovaShapes {
    val small = RoundedCornerShape(4.dp)       // 0.25rem — minimal rounding
    val medium = RoundedCornerShape(8.dp)      // 0.5rem — telemetry pods & sub-tiles
    val large = RoundedCornerShape(12.dp)      // 0.75rem — mid-level containers
    val extraLarge = RoundedCornerShape(16.dp) // 1rem — primary cards & containers
    val pill = RoundedCornerShape(9999.dp)     // Full capsule — pills, badges, nav dock

    val card = extraLarge     // Default card shape
    val chip = pill           // Status chips & badges
    val button = medium       // Action buttons
    val navBar = pill         // Floating navigation dock
    val icon = large          // Icon containers
}
