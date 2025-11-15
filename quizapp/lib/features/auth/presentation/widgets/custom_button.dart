import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? bgColor; 
  final Color? fgColor; 

  const AuthButton({
    super.key, 
    required this.onPressed, 
    required this.title, 
    this.bgColor  = AppColors.primaryPurple,  
    this.fgColor = AppColors.primaryPurple,
    
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width *
          0.8, // Set a wide but constrained width
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Adding a subtle elevation/shadow for better depth
          elevation: 5,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
