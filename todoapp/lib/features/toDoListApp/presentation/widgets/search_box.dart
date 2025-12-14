import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 61, 107, 91);
    const Color surfaceColor = Color.fromARGB(255, 246, 247, 248);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Material(
        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30.0),
        color: surfaceColor,
        child: TextField(
          onChanged: (value) {
            Provider.of<TaskProvider>(
              context,
              listen: false,
            ).setSearchQuery(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: primaryColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),

            hintText: 'Search your tasks...',
            hintStyle: TextStyle(
              color: primaryColor.withOpacity(0.6),
              fontSize: 16,
            ),

            prefixIcon: const Icon(Icons.search, color: primaryColor, size: 24),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
          ),
          style: const TextStyle(color: primaryColor, fontSize: 16),
          cursorColor: primaryColor,
        ),
      ),
    );
  }
}
