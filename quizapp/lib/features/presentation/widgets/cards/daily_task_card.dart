import "package:flutter/material.dart";
import "package:quizapp/core/constants/appcolors.dart";
class DailyTaskCard extends StatefulWidget {
  const DailyTaskCard({super.key});

  @override
  State<DailyTaskCard> createState() => _DailyTaskCardState();
}

class _DailyTaskCardState extends State<DailyTaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.6, 0.2), // from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

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
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.anchor,
                      color: AppColors.surfaceWhite,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Task',
                          style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '8 days strike',
                          style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.accentPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.stacked_line_chart_rounded,
                      color: AppColors.surfaceWhite,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 8 / 14,
                      backgroundColor: AppColors.surfaceWhite.withOpacity(0.4),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentPink,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '8/14',
                    style: TextStyle(
                      color: AppColors.surfaceWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}