package com.recova.app.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.recova.app.ui.theme.RecovaColors

/**
 * Signature Radial Score Gauge
 *
 * 220px circular vector arc with an 8px track width.
 * Track: recessed rgba(255,255,255,0.06) with rounded stroke ends.
 * Active arc: dynamically painted in the domain accent color.
 * Includes atmospheric back-glow for high-potency metrics.
 *
 * @param score The score value (0–100 for percentage, 0–21 for strain)
 * @param maxScore The maximum score value
 * @param accentColor The color of the active arc
 * @param glowColor The atmospheric glow color
 * @param size The diameter of the gauge
 * @param trackWidth The width of the arc stroke
 * @param content Center content composable (score text, status pill, etc.)
 */
@Composable
fun RadialScoreGauge(
    score: Float,
    maxScore: Float = 100f,
    accentColor: Color = RecovaColors.recoveryEmerald,
    glowColor: Color = RecovaColors.glowRecovery,
    size: Dp = 210.dp,
    trackWidth: Dp = 4.5.dp,
    animated: Boolean = true,
    content: @Composable BoxScope.() -> Unit
) {
    val percentage = (score / maxScore).coerceIn(0f, 1f)

    // Animate the arc sweep
    val animatedPercentage by animateFloatAsState(
        targetValue = if (animated) percentage else percentage,
        animationSpec = tween(
            durationMillis = 1200,
            easing = FastOutSlowInEasing
        ),
        label = "gaugeArc"
    )

    // Subtle pulse for the glow
    val infiniteTransition = rememberInfiniteTransition(label = "glowPulse")
    val glowAlpha by infiniteTransition.animateFloat(
        initialValue = 0.15f,
        targetValue = 0.35f,
        animationSpec = infiniteRepeatable(
            animation = tween(3000, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "glowAlpha"
    )

    Box(
        modifier = Modifier.size(size),
        contentAlignment = Alignment.Center
    ) {
        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            val canvasSize = this.size
            val strokeWidthPx = trackWidth.toPx()
            val padding = strokeWidthPx / 2 + 8.dp.toPx()
            val arcSize = Size(
                canvasSize.width - padding * 2,
                canvasSize.height - padding * 2
            )
            val topLeft = Offset(padding, padding)

            // Atmospheric back-glow
            if (percentage > 0.5f) {
                drawCircle(
                    color = glowColor.copy(alpha = glowAlpha * percentage),
                    radius = canvasSize.width / 2 - padding,
                    center = Offset(canvasSize.width / 2, canvasSize.height / 2)
                )
            }

            // Background track (recessed)
            drawArc(
                color = Color.White.copy(alpha = 0.04f),
                startAngle = -225f,
                sweepAngle = 270f,
                useCenter = false,
                topLeft = topLeft,
                size = arcSize,
                style = Stroke(width = strokeWidthPx, cap = StrokeCap.Round)
            )

            // Tick marks on track
            drawArc(
                color = Color.White.copy(alpha = 0.08f),
                startAngle = -225f,
                sweepAngle = 270f,
                useCenter = false,
                topLeft = topLeft,
                size = arcSize,
                style = Stroke(
                    width = strokeWidthPx,
                    cap = StrokeCap.Round,
                    pathEffect = androidx.compose.ui.graphics.PathEffect.dashPathEffect(
                        floatArrayOf(1f, 7f * strokeWidthPx / 4f),
                        0f
                    )
                )
            )

            // Active arc with glow
            if (animatedPercentage > 0f) {
                val sweepAngle = 270f * animatedPercentage

                // Arc glow (slightly wider, blurred)
                drawArc(
                    color = accentColor.copy(alpha = 0.25f),
                    startAngle = -225f,
                    sweepAngle = sweepAngle,
                    useCenter = false,
                    topLeft = topLeft,
                    size = arcSize,
                    style = Stroke(width = strokeWidthPx + 4.dp.toPx(), cap = StrokeCap.Round)
                )

                // Main active arc
                drawArc(
                    color = accentColor,
                    startAngle = -225f,
                    sweepAngle = sweepAngle,
                    useCenter = false,
                    topLeft = topLeft,
                    size = arcSize,
                    style = Stroke(width = strokeWidthPx, cap = StrokeCap.Round)
                )
            }
        }

        // Center content
        content()
    }
}
