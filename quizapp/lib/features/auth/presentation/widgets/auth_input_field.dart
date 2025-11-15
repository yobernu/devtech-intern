import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class AuthInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final bool isObscure;

  const AuthInputField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.icon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine input type for keyboard hint
    final TextInputType keyboardType = labelText == 'Email'
        ? TextInputType.emailAddress
        : (isObscure ? TextInputType.text : TextInputType.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.surfaceWhite, fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: AppColors.primaryPurple.withOpacity(0.7)),
          fillColor: AppColors.surfaceWhite.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide
                .none, // Use filled color instead of border for a modern look
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.inputBorder.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.surfaceWhite,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          if (labelText == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email address';
          }
          if (labelText == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
