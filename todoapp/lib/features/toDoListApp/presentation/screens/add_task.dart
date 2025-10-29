import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/show_modal.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_appBar.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_button.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/search_box.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 164, 161),
      appBar: CustomAppBar(title: 'Simple to do app'),
      body: Column(
        children: [
          SizedBox(height: 32.0),
          Center(
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Icon(
                Icons.note_alt,
                size: 120,
                color: const Color.fromARGB(255, 192, 207, 203),
              ),
            ),
          ),
          Text(
            'Add New Task',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
          ),
          CustomButton(
            onPress: () => showModal(context),
            title: 'Add Task',
            prefIcon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
