import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final List<Color> isActiveColor;
  final VoidCallback onTap;

  const AnimatedNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isActiveColor = const [
      Color.fromRGBO(255, 102, 178, 1),
      Color.fromRGBO(182, 98, 255, 1),
    ],
    required this.onTap,
  });

  @override
  State<AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.surfaceWhite;
    final textStyle = TextStyle(
      color: iconColor,
      fontSize: 10,
      fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.isActive
              ? Container(
                  height: 70,
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accentPink, AppColors.secondaryPurple],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: iconColor, size: 28),
                      Text(widget.label, style: textStyle),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: iconColor, size: 20),
                    Text(widget.label, style: textStyle),
                  ],
                ),
        ),
      ),
    );
  }
}
