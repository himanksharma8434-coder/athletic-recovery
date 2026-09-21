import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class BottomPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const BottomPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xE60E1014),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.monitor_heart_outlined,
                activeIcon: Icons.monitor_heart,
                label: 'Pulse',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: 'Recovery',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.bolt_outlined,
                activeIcon: Icons.bolt,
                label: 'Strain',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.bedtime_outlined,
                activeIcon: Icons.bedtime,
                label: 'Sleep',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? RecovaColors.monochromeWhite
        : RecovaColors.textTertiary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: color,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.5,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              if (isSelected)
                Container(
                  width: 3.5,
                  height: 3.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: RecovaColors.monochromeWhite,
                  ),
                )
              else
                const SizedBox(height: 3.5),
            ],
          ),
        ),
      ),
    );
  }
}
