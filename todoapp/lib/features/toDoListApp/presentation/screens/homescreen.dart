import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_appBar.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_button.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/search_box.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(key: key, title: 'Simple to do app'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SearchBox(),
            SizedBox(height: 32.0),
            // TaskRow(key: key, title: 'Task 1', timeInterval: '12:00 PM'),
            // TaskRow(key: key, title: 'Task 2', timeInterval: '12:00 PM'),
            // TaskRow(key: key, title: 'Task 3', timeInterval: '12:00 PM'),
          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF466A5E), Color(0xFF89D0B8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Add task logic
          },
        ),
      ),
    );
  }
}
