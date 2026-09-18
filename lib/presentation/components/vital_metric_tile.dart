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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: RecovaColors.textTertiary,
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: RecovaColors.textPrimary,
                ),
              ),
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
          ),
          const SizedBox(height: 4),
          Text(
            deltaText,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: deltaColor ?? RecovaColors.recoveryEmerald,
            ),
          ),
        ],
      ),
    );
  }
}
