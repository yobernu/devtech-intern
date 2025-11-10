import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final String title;
  final String description;
  final String timeInterval;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskRow({
    Key? key,
    required this.title,
    this.description = "",
    required this.timeInterval,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  // Helper function to scale sizes based on screen width (kept from original code)
  double scale(double size, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return size * (screenWidth / 375);
  }

  @override
  Widget build(BuildContext context) {
    // Define a modern color palette
    const Color primaryColor = Color(0xFF4C7FFF); // A vibrant blue
    const Color completedColor = Color(0xFF17D092); // A fresh green
    const Color cardBgColor = Colors.white;
    const Color shadowColor = Color(
      0xFF3B5B9E,
    ); // Shadow color based on primary
    final Color textColor = isCompleted ? Colors.grey.shade600 : Colors.black87;
    final Color subtitleColor = isCompleted
        ? Colors.grey.shade400
        : Colors.grey;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          // Subtle border when not completed, a highlight when completed
          border: isCompleted
              ? Border.all(color: completedColor.withOpacity(0.5), width: 1.5)
              : Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(isCompleted ? 0.1 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        // Using ListTile structure for better alignment and standard design
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: [
              // Modern Checkbox Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: scale(28, context),
                height: scale(28, context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? completedColor : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? completedColor
                        : primaryColor.withOpacity(0.7),
                    width: isCompleted ? 0 : 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Container(), // Empty container when not checked
                ),
              ),
              const SizedBox(width: 16),

              // Title and Time Interval
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: scale(16, context),
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: completedColor,
                        decorationThickness: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2 ,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: scale(12, context),
                        fontWeight: FontWeight.w400,
                        color: textColor,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: completedColor,
                        decorationThickness: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeInterval,
                      style: TextStyle(
                        fontSize: scale(13, context),
                        color: subtitleColor,
                        // No font change to avoid external dependencies like 'preahvihear'
                      ),
                    ),
                  ],
                ),
              ),

              // Delete Button (onDelete logic remains the same)
              GestureDetector(
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent.withOpacity(0.7),
                    size: scale(24, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
