import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_bloc.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_event.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_otpController.text.trim().length == 6) {
      context.read<AuthBloc>().add(
        VerifyOtpRequestedEvent(
          phone: widget.phoneNumber,
          token: _otpController.text.trim(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Verify Phone"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MeshGradientBackground(
        child: BlocConsumer<AuthBloc, UserState>(
          listener: (context, state) {
            if (state is UserLogInSuccessState) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            } else if (state is UserFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Verification Failed: ${state.failure.message}',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is UserLoadingState;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.surfaceWhite,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sent to ${widget.phoneNumber}',
                      style: const TextStyle(
                        color: AppColors.surfaceWhite,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AuthInputField(
                      labelText: '6-Digit Code',
                      controller: _otpController,
                      icon: Icons.lock_clock,
                      //  keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    AuthButton(
                      onPressed: isLoading ? () {} : _handleVerify,
                      title: isLoading ? 'VERIFYING...' : 'VERIFY',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
