import 'package:flutter/material.dart';
// Assuming AppColors provides colors like primaryPurple and surfaceWhite
import 'package:quizapp/core/constants/appcolors.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  // New: Optional trailing widget (e.g., Switch, Text, or badge)
  final Widget? trailing;
  // New: Use a specific background color for the icon container
  final Color? iconBackgroundColor;

  const SettingsItem({
    super.key, // Use super.key
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color defaultIconBg = iconBackgroundColor ?? AppColors.primaryPurple;
    final Color defaultTextColor = colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        // Slightly reduced horizontal padding for a cleaner look
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
        child: Row(
          children: [
            // 1. Icon Container
            Container(
              height: 44, // Slightly larger container
              width: 44,
              decoration: BoxDecoration(
                color: defaultIconBg,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Use squared corners for a modern feel
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 24, // Slightly smaller icon
                  color: AppColors
                      .surfaceWhite, // Keep the icon white for contrast
                ),
              ),
            ),

            const SizedBox(width: 20), // Reduced spacing
            // 2. Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17, // Slightly smaller text
                  fontWeight: FontWeight.w500,
                  color: defaultTextColor,
                ),
              ),
            ),

            // 3. Trailing Widget (Flexibility added here)
            if (trailing != null)
              trailing!
            else
              // Default to the forward arrow if no trailing widget is provided
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }
}
