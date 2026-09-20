import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class CoachInsightCard extends StatelessWidget {
  final double? recoveryScore;
  final String? primaryFactor;

  const CoachInsightCard({
    super.key,
    required this.recoveryScore,
    this.primaryFactor,
  });

  @override
  Widget build(BuildContext context) {
    final score = recoveryScore ?? 50;
    final tier = RecoveryTier.fromScore(recoveryScore);

    String insightText;
    String strainTarget;
    String optimalWindow;

    if (score >= 80) {
      insightText =
          'Your parasympathetic balance is optimal today. Recommended target strain: ';
      strainTarget = '14.5 – 17.2';
      optimalWindow = 'OPTIMAL WINDOW: 10:30 AM - 2:00 PM';
    } else if (score >= 50) {
      insightText =
          'Moderate autonomic recovery detected. Maintain steady conditioning. Target strain: ';
      strainTarget = '10.0 – 13.5';
      optimalWindow = 'RECOMMENDED: AEROBIC ZONE 2 TRAINING';
    } else {
      insightText =
          'Suppressed recovery indicated (${primaryFactor ?? 'Resting HR elevated'}). Prioritize sleep & active recovery. Target strain: ';
      strainTarget = '6.0 – 9.0';
      optimalWindow = 'ACTIVE RECOVERY & HYDRATION ONLY';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.psychology_outlined,
                      size: 15, color: RecovaColors.monochromeWhite),
                  SizedBox(width: 8),
                  Text(
                    'COACH INSIGHT',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                'AUTONOMIC AI',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: RecovaColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Insight Narrative
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: RecovaColors.textSecondary,
              ),
              children: [
                TextSpan(text: insightText),
                TextSpan(
                  text: strainTarget,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tier.color,
                  ),
                ),
                const TextSpan(
                    text: '. Tailored to your baseline & daily telemetry.'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Footer Window
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: RecovaColors.borderSubtle)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tier.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      optimalWindow,
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      'DETAILS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: RecovaColors.textSecondary,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        size: 12, color: RecovaColors.textTertiary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
