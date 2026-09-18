import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/recova_colors.dart';
import '../cubits/health_permission/health_permission_cubit.dart';
import '../cubits/health_permission/health_permission_state.dart';
import 'main_shell_screen.dart';

/// Kinetic Obsidian styled Permission onboarding screen.
/// Explains why health data is needed and requests authorization.
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial check in case permissions were already granted
    context.read<HealthPermissionCubit>().checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When returning from Health Connect settings, auto-verify permissions
      context.read<HealthPermissionCubit>().checkPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthPermissionCubit, HealthPermissionState>(
      listener: (context, state) {
        if (state is HealthPermissionGranted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainShellScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: RecovaColors.canvasBase,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RecovaColors.surfaceElevation1,
                    border: Border.all(color: RecovaColors.borderMedium),
                    boxShadow: [
                      BoxShadow(
                        color:
                            RecovaColors.recoveryEmerald.withValues(alpha: 0.15),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt,
                    size: 48,
                    color: RecovaColors.recoveryEmerald,
                  ),
                ),
                const SizedBox(height: 28),

                // Title
                const Text(
                  'CONNECT WEARABLE TELEMETRY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: RecovaColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Rationale
                const Text(
                  'Recova reads heart rate, sleep architecture, SpO2, and workouts from Nothing X / CMF Watch via Health Connect.\n\n'
                  'All telemetry is computed locally on-device. Zero cloud transmission.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: RecovaColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Data types
                const _DataTypeChip(
                  icon: Icons.favorite_outline,
                  label: 'Heart Rate & Resting HR',
                  accentColor: RecovaColors.recoveryEmerald,
                ),
                const SizedBox(height: 8),
                const _DataTypeChip(
                  icon: Icons.bedtime_outlined,
                  label: 'Sleep Stages & Architecture',
                  accentColor: RecovaColors.restorativeAzure,
                ),
                const SizedBox(height: 8),
                const _DataTypeChip(
                  icon: Icons.air,
                  label: 'Blood Oxygen Saturation (SpO2)',
                  accentColor: RecovaColors.kineticAmberGold,
                ),
                const SizedBox(height: 8),
                const _DataTypeChip(
                  icon: Icons.directions_run,
                  label: 'Workouts, Steps & Active Energy',
                  accentColor: RecovaColors.recoveryEmeraldBright,
                ),
                const SizedBox(height: 8),
                const _DataTypeChip(
                  icon: Icons.thermostat_outlined,
                  label: 'Respiration, Vitals & Temperature',
                  accentColor: RecovaColors.neuralViolet,
                ),
                const SizedBox(height: 32),

                // Primary Connect button
                BlocBuilder<HealthPermissionCubit, HealthPermissionState>(
                  builder: (context, state) {
                    final isLoading = state is HealthPermissionRequesting;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: isLoading
                            ? null
                            : () => context
                                .read<HealthPermissionCubit>()
                                .requestPermissions(),
                        style: FilledButton.styleFrom(
                          backgroundColor: RecovaColors.recoveryEmerald,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'GRANT HEALTH CONNECT ACCESS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Secondary Fallback: Direct Proceed / Verify button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      // Navigate straight to dashboard
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const MainShellScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: RecovaColors.textTertiary,
                    ),
                    child: const Text(
                      'I\'VE ALREADY GRANTED ACCESS • PROCEED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                // Denied or Notice message
                BlocBuilder<HealthPermissionCubit, HealthPermissionState>(
                  builder: (context, state) {
                    if (state is HealthPermissionDenied) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 11,
                            color: RecovaColors.kineticAmberGold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DataTypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;

  const _DataTypeChip({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: RecovaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
