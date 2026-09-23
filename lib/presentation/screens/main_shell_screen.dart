import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';
import '../components/bottom_pill_nav_bar.dart';
import '../cubits/dashboard/dashboard_cubit.dart';
import '../cubits/dashboard/dashboard_state.dart';
import '../cubits/health_sync/health_sync_cubit.dart';
import '../cubits/health_sync/health_sync_state.dart';
import 'pulse_screen.dart';
import 'recovery_deep_dive_screen.dart';
import 'strain_screen.dart';
import 'sleep_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load();
    // Auto-sync on startup: pull latest wearable data immediately
    _autoSync();
  }

  void _autoSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<HealthSyncCubit>().syncNow();
      if (mounted) {
        context.read<DashboardCubit>().refresh();
      }
    });
  }


  void _onSyncTap() async {
    await context.read<HealthSyncCubit>().syncNow();
    if (mounted) {
      context.read<DashboardCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RecovaColors.canvasBase,
      body: BlocConsumer<HealthSyncCubit, HealthSyncState>(
        listener: (context, syncState) {
          if (syncState is HealthSyncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: RecovaColors.recoveryEmerald, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Synced ${syncState.recordCount} health records from wearable',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                backgroundColor: RecovaColors.surfaceElevation3,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: RecovaColors.borderSubtle),
                ),
              ),
            );
          } else if (syncState is HealthSyncFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sync failed: ${syncState.message}'),
                backgroundColor: RecovaColors.stressCrimson,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, syncState) {
          return BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              DerivedMetricSummary? summary;
              if (state is DashboardLoaded) {
                summary = state.summary;
              }

              return Stack(
                children: [
                  // Safe Area wrapped IndexedStack
                  SafeArea(
                    bottom: false,
                    child: IndexedStack(
                      index: _currentTab,
                      children: [
                        PulseScreen(
                          summary: summary,
                          onSyncTap: _onSyncTap,
                        ),
                        RecoveryDeepDiveScreen(
                          summary: summary,
                        ),
                        StrainScreen(
                          summary: summary,
                        ),
                        SleepScreen(
                          summary: summary,
                        ),
                      ],
                    ),
                  ),

                  // Floating Pill Bottom Navigation Bar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomPillNavBar(
                      selectedIndex: _currentTab,
                      onTabSelected: (index) {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
