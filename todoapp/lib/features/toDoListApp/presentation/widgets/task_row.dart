import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final String title;
  final String timeInterval;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskRow({
    Key? key,
    required this.title,
    required this.timeInterval,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scale(double size) => size * (screenWidth / 375);

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCompleted
                ? [
                    const Color(0xFF17D092).withOpacity(0.8),
                    const Color(0xFF0B6E4F).withOpacity(0.9),
                  ]
                : [
                    const Color(0xFF17D092).withOpacity(0.3),
                    const Color(0xFF00C896).withOpacity(0.5),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.white.withOpacity(0.9)
                    : Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.9),
                  width: 2,
                ),
              ),
              width: scale(28),
              height: scale(28),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle_outlined,
                color: isCompleted
                    ? const Color(0xFF17D092)
                    : Colors.white.withOpacity(0.7),
                size: scale(20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: scale(16),
                      fontFamily: 'preahvihear',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeInterval,
                    style: TextStyle(
                      fontSize: scale(13),
                      fontFamily: 'preahvihear',
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.15),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent.withOpacity(0.7),
                  size: scale(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
