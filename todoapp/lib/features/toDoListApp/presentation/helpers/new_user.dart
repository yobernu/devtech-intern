import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/show_modal.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_button.dart';

class Newuser extends StatelessWidget {
  const Newuser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF466A5E);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFD0E8DB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✨ Greeting text
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 800),
            child: Text(
              'Welcome Back 👋',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'preahvihear',
                color: Color(0xFF2F3E46),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📝 Animated icon card
          AnimatedScale(
            duration: const Duration(milliseconds: 800),
            scale: 1.1,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.note_alt_outlined,
                size: 80,
                color: Color(0xFF466A5E),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ✍️ Prompt text
          Text(
            'Add Your First Task',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'preahvihear',
              color: themeColor,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Organize your day and stay productive!',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'preahvihear',
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 40),

          // ✅ Add task button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CustomButton(
              onPress: () => showModal(context),
              title: 'Add Task',
              prefIcon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
