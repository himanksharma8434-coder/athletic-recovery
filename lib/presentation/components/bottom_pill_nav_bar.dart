import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

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
        padding: const EdgeInsets.only(
          bottom: Tok.space12,
          left: Tok.space24,
          right: Tok.space24,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: Tok.space8),
              decoration: BoxDecoration(
                color: Tok.canvasBase.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(36),
                border: Border(
                  top: BorderSide(
                    color: Tok.glassBorderBright,
                    width: 0.5,
                  ),
                  left: BorderSide(
                    color: Tok.glassBorder.withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                  right: BorderSide(
                    color: Tok.glassBorder.withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                  bottom: BorderSide(
                    color: Tok.glassBorder.withValues(alpha: 0.04),
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  // Subtle neon glow under the bar
                  BoxShadow(
                    color: Tok.neonAccent.withValues(alpha: 0.06),
                    blurRadius: 32,
                    offset: const Offset(0, 2),
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
    final color = isSelected ? Tok.neonAccent : Tok.textTertiary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Tok.space4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: Tok.animFast,
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: Tok.space2),
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
              const SizedBox(height: Tok.space2),
              AnimatedContainer(
                duration: Tok.animFast,
                width: isSelected ? 3.5 : 0,
                height: isSelected ? 3.5 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Tok.neonAccent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Tok.neonAccent.withValues(alpha: 0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
              ),
              if (!isSelected) const SizedBox(height: 3.5),
            ],
          ),
        ),
      ),
    );
  }
}
