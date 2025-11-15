// Widget to represent a large Quiz category card
import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
class MoreGameCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final String score;
  final String questions;

  const MoreGameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.score,
    required this.questions,
  });

  @override
  State<MoreGameCard> createState() => _MoreGameCardState();
}

class _MoreGameCardState extends State<MoreGameCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0.6, 0), // slide in from right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with Gradient Background
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [widget.gradientStart, widget.gradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(widget.icon, color: AppColors.surfaceWhite, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  widget.questions,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkText.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.play_circle_fill_sharp, size: 16, color: AppColors.accentPink),
                    const SizedBox(width: 4),
                    Text(
                      widget.score,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.darkText,
                      ),
                    ),
                    const Spacer(),

                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color:AppColors.smallButtonBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      
                      child: Center(child: const Icon(Icons.flash_on, size: 16, color: AppColors.surfaceWhite))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}