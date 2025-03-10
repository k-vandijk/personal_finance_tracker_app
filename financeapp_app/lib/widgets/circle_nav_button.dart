import 'package:flutter/material.dart';

class CircleNavButton extends StatelessWidget {
  final double inactiveSize;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  static const double _activeSizeMultiplier = 1.2;
  static const Duration _animationDuration = Duration(milliseconds: 50);

  const CircleNavButton({
    super.key,
    required this.inactiveSize,
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double activeSize = inactiveSize * _activeSizeMultiplier;
    final double size = active ? activeSize : inactiveSize;
    final Color backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    final Color iconColor = Theme.of(context).colorScheme.onSecondaryContainer;

    return SizedBox(
      width: activeSize,
      height: activeSize,
      child: Center(
        child: AnimatedContainer(
          duration: _animationDuration,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: iconColor,
            iconSize: size * 0.6,
          ),
        ),
      ),
    );
  }
}
