import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;

  const TitleInput({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              labelText: label,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0xFFCAE2DA),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
