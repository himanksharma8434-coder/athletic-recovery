import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import 'glass_card.dart';

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
    final effectiveDeltaColor =
        deltaColor == Tok.recoverySuppressed
            ? Tok.recoverySuppressed
            : Tok.textSecondary;

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: Tok.space12,
        vertical: Tok.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: Tok.textTertiary),
                const SizedBox(width: Tok.space4),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TokType.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: Tok.space6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TokType.metricMedium,
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: Tok.space2),
                Text(unit, style: TokType.unit),
              ],
            ],
          ),
          const SizedBox(height: Tok.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (effectiveDeltaColor == Tok.recoverySuppressed) ...[
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: Tok.space4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Tok.recoverySuppressed,
                    boxShadow: [
                      BoxShadow(
                        color: Tok.recoverySuppressed.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
              Flexible(
                child: Text(
                  deltaText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TokType.caption.copyWith(
                    fontWeight: FontWeight.w400,
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
