import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';

// Bloc imports
import 'package:quizapp/features/presentation/provider/auth/auth_bloc.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_event.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      if (_isPhoneLogin) {
        context.read<AuthBloc>().add(
          PhoneSignInRequestedEvent(phoneNumber: _phoneController.text.trim()),
        );
      } else {
        context.read<AuthBloc>().add(
          LogInRequestedEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      }
    }
  }

  void _handleGoogleLogin() {
    context.read<AuthBloc>().add(GoogleSignInRequestedEvent());
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: MeshGradientBackground(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [AppColors.secondaryPurple, AppColors.primaryPurple],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: BlocConsumer<AuthBloc, UserState>(
          listener: (context, state) {
            if (state is UserLogInSuccessState) {
              _showSnackbar('Login successful! Welcome back.');
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            } else if (state is UserOtpSentState) {
              _showSnackbar('OTP Sent to ${state.phoneNumber}');
              Navigator.pushNamed(
                context,
                AppRoutes.otpVerification,
                arguments: {'phoneNumber': state.phoneNumber},
              );
            } else if (state is UserFailureState) {
              _showSnackbar(
                'Login Failed: ${state.failure.message}',
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
                      // Logo/Header
                      SizedBox(height: size.height * 0.1),
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite.withOpacity(1),
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
                              'assets/images/quizlogo.png',
                              width: 105,
                              height: 105,
                              fit: BoxFit.cover,
                              // color: AppColors.primaryPurple,
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

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (_isPhoneLogin)
                              AuthInputField(
                                labelText: 'Phone Number (e.g., +1555...)',
                                controller: _phoneController,
                                icon: Icons.phone,
                                // keyboardType: TextInputType.phone,
                              )
                            else ...[
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
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 32.0),
                                  child: TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            Navigator.pushNamed(
                                              context,
                                              "/forgotPassword",
                                            );
                                          },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: AppColors.darkText.withOpacity(
                                          0.8,
                                        ),
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

                      const SizedBox(height: 40),
                      AuthButton(
                        onPressed: isLoading ? () {} : _handleLogin,
                        title: isLoading
                            ? "PROCESSING..."
                            : (_isPhoneLogin ? "SEND OTP" : "SIGN IN"),
                        fgColor: AppColors.lightSurface,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: AppColors.surfaceWhite),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(color: AppColors.surfaceWhite),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AppColors.surfaceWhite),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onPressed: () {
                          setState(() {
                            _isPhoneLogin = !_isPhoneLogin;
                          });
                        },
                        title: _isPhoneLogin
                            ? "Continue with Email"
                            : "Continue with Phone",
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.surfaceWhite,
                        fgColor: AppColors.surfaceWhite,
                      ),
                      const SizedBox(height: 10),

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
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.signup,
                                    );
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


// navigator