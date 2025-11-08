import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Use a global key for the Form widget to enable validation checks
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // IMPORTANT: Dispose controllers to free up memory (Professional practice)
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Submission handler function
  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, AppRoutes.home);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processing Login Data...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // Background Gradient
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
                  // Logo/Header Space
                  SizedBox(height: size.height * 0.1),
                  Center(
                    // Using a placeholder image for demonstration
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ),

                  // Title
                  SizedBox(height: size.height * 0.05),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: AppColors.surfaceWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Access Your Account',
                    style: TextStyle(
                      color: AppColors.surfaceWhite,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Area
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthInputField(
                          labelText: 'Email',
                          controller: _emailController,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        AuthInputField(
                          labelText: 'Password',
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          isObscure: true,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 32.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/forgotPassword",
                                  );
                                },
                                child: Text(
                                  "Forgot Passoword?",
                                  style: TextStyle(
                                    color: AppColors.darkText.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Submission Button
                  const SizedBox(height: 40),
                  AuthButton(onPressed: _handleSignIn, title: "SIGN IN"),

                  // Login Redirect
                  const SizedBox(height: 20),
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
                          Navigator.pushNamed(context, AppRoutes.signup);
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
                  // Flexible space pushes content towards the middle
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// appcolors