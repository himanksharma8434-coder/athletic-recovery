import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class VitalMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String deltaText;
  final Color? deltaColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const VitalMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.deltaText,
    this.deltaColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // In Nothing X monochrome style, default to cool silver/white unless explicit critical alert
    final effectiveDeltaColor = deltaColor == RecovaColors.nothingRed || deltaColor == RecovaColors.stressCrimson
        ? RecovaColors.nothingRed
        : RecovaColors.textSecondary;

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: RecovaColors.textTertiary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.4,
                  color: RecovaColors.textPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (effectiveDeltaColor == RecovaColors.nothingRed) ...[
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 4),
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
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                    color: effectiveDeltaColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
