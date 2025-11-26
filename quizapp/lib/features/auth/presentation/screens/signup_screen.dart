import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/helpers/alerts/show_custom_snack_bar.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';
// BLoC Imports
import 'package:quizapp/features/presentation/provider/auth/auth_bloc.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_event.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      debugPrint(
        'Signup button pressed ${_usernameController.text.trim()} ${_emailController.text.trim()} ${_passwordController.text.trim()}',
      );
      context.read<AuthBloc>().add(
        SignUpRequestedEvent(
          name: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  // void _showSnackbar(String message, {bool isError = false}) {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: isError ? Colors.redAccent : Colors.green,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: MeshGradientBackground(
        // Background Gradient
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [AppColors.secondaryPurple, AppColors.primaryPurple],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        // Use BlocConsumer to listen for state changes and rebuild the UI
        child: BlocConsumer<AuthBloc, UserState>(
          listener: (context, state) {
            if (state is UserSignUpSuccessState) {
              showSnackbar(
                context,
                'Signup successful! Welcome.',
                isError: false,
              );
              // Navigate to Home screen on success
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            } else if (state is UserFailureState) {
              showSnackbar(
                context,
                'Signup Failed: ${state.failure.message}',
                isError: true,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is UserLoadingState;

            return SingleChildScrollView(
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
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite.withOpacity(0.8),
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
                        'Create Your Account',
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
                              labelText: 'Username',
                              controller: _usernameController,
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
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
                          ],
                        ),
                      ),

                      // Submission Button
                      const SizedBox(height: 40),
                      AuthButton(
                        onPressed: isLoading ? () {} : _handleSignup,
                        title: isLoading ? "PROCESSING..." : "SIGN UP",
                        fgColor: AppColors.lightSurface,
                      ),

                      // Login Redirect
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColors.inputBorder,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                            child: const Text(
                              'Log In',
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
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
