import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final String title;
  final String timeInterval;

  const TaskRow({Key? key, required this.title, required this.timeInterval})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive scaling
    final screenWidth = MediaQuery.of(context).size.width;

    // Define a scale factor (base width = 375 for iPhone 11-like screen)
    double scale(double size) => size * (screenWidth / 375);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF466A5E), Color(0xFF89D0B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6],
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(24.0, 6, 24.0, 6),
      padding: const EdgeInsets.fromLTRB(16.0, 10, 16.0, 10),
      child: Row(
        children: [
          Icon(Icons.check_box_outline_blank, size: scale(22)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: scale(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeInterval,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: scale(13),
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.delete,
            color: Colors.red.withOpacity(0.4),
            size: scale(22),
          ),
        ],
      ),
    );
  }
}
