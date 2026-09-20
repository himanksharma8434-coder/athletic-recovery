import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class VitalMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String deltaText;
  final Color? deltaColor;
  final IconData? icon;

  const VitalMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.deltaText,
    this.deltaColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // In Nothing X monochrome style, default to cool silver/white unless explicit critical alert
    final effectiveDeltaColor = deltaColor == RecovaColors.nothingRed || deltaColor == RecovaColors.stressCrimson
        ? RecovaColors.nothingRed
        : RecovaColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 11, color: RecovaColors.textTertiary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: RecovaColors.textPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (effectiveDeltaColor == RecovaColors.nothingRed) ...[
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: RecovaColors.nothingRed,
                  ),
                ),
              ],
              Flexible(
                child: Text(
                  deltaText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: effectiveDeltaColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
