import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Submission handler function
  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send the request to your authentication service here.
      // Navigator.pushNamed(context, AppRoutes.home); // Placeholder navigation

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link sent to ${_emailController.text}.',
            style: const TextStyle(color: AppColors.surfaceWhite),
          ),
          backgroundColor: AppColors.primaryPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.surfaceWhite),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryPurple, AppColors.primaryPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter your email address and we\'ll send you a link to securely reset your password.',
                          style: TextStyle(
                            color: AppColors.inputBorder,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Form Area
                  Form(
                    key: _formKey,
                    child: AuthInputField(
                      labelText: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),
                  ),

                  // Submission Button
                  const SizedBox(height: 40),
                  AuthButton(
                    onPressed: _handleForgotPassword,
                    title: "SEND RESET LINK",
                  ),

                  // Signup Redirect
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: AppColors.inputBorder,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Replace with actual navigation logic
                          // Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.surfaceWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3), // Push content towards the top-middle
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
