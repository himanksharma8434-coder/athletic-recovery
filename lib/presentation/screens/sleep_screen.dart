import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

class SleepScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;

  const SleepScreen({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final totalHours = summary?.sleepHours ?? 7.8;
    final hours = totalHours.floor();
    final mins = ((totalHours - hours) * 60).round();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SLEEP ARCHITECTURE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: RecovaColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: RecovaColors.restorativeAzureContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RecovaColors.restorativeAzureBorder),
                ),
                child: const Text(
                  '92% PERFORMANCE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: RecovaColors.restorativeAzure,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Sleep Duration Hero Card ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL TIME ASLEEP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${hours}h',
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1.0,
                                color: RecovaColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mins}m',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                color: RecovaColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RecovaColors.restorativeAzureContainer,
                        border: Border.all(
                            color: RecovaColors.restorativeAzureBorder),
                      ),
                      child: const Icon(
                        Icons.bedtime,
                        size: 32,
                        color: RecovaColors.restorativeAzure,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '+22m vs 7-day baseline • Deep restoration achieved',
                  style: TextStyle(
                    fontSize: 11,
                    color: RecovaColors.recoveryEmerald,
                  ),
                ),
                const SizedBox(height: 14),

                // Multi-Stage Color Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 28, // Deep 28%
                          child:
                              Container(color: RecovaColors.restorativeAzure),
                        ),
                        Expanded(
                          flex: 22, // REM 22%
                          child: Container(color: RecovaColors.neuralViolet),
                        ),
                        Expanded(
                          flex: 42, // Light 42%
                          child: Container(
                              color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        Expanded(
                          flex: 8, // Awake 8%
                          child: Container(
                              color: RecovaColors.stressCrimson
                                  .withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Sleep Stages Breakdown ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STAGE ARCHITECTURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: RecovaColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 14),
                _buildStageRow('Deep Sleep (Slow Wave)', '2h 11m', '28%',
                    'Physical restoration & GH release', RecovaColors.restorativeAzure),
                const SizedBox(height: 12),
                _buildStageRow('REM Sleep', '1h 43m', '22%',
                    'Cognitive memory consolidation', RecovaColors.neuralViolet),
                const SizedBox(height: 12),
                _buildStageRow('Light Sleep', '3h 16m', '42%',
                    'Baseline metabolic stabilization',
                    Colors.white.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                _buildStageRow('Awake Periods', '38m', '8%',
                    'Micro-arousals during nocturnal transitions',
                    RecovaColors.stressCrimson),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Sleep Quality Markers ──
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation1,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SLEEP EFFICIENCY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '94%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.recoveryEmerald,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Optimal latency',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: RecovaColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation1,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'RHR DIP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '-14.2%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.restorativeAzure,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Healthy nocturnal dip',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: RecovaColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageRow(
    String stage,
    String duration,
    String percentage,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stage,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '($percentage)',
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: RecovaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
