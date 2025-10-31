import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true, // ✅ Enables background fill
          fillColor: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ).withOpacity(0.3), // ✅ Your custom background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          hintText: 'Search ... ',
          hintStyle: const TextStyle(
            color: Color(0xFF466A5E),
            fontFamily: 'preahvihear',
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF466A5E)),
        ),
      ),
    );
  }
}
