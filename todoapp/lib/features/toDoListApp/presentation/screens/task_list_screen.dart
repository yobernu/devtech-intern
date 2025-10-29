import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/show_modal.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/task_list.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_appBar.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();

    // Access provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    if (taskProvider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(taskProvider.errorMessage!)));
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 164, 161),
      appBar: const CustomAppBar(title: 'Simple To-Do App'),
      body: TaskList(
        tasks: taskProvider.tasks, // use tasks from provider
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
