import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/update_task.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class TaskList extends StatefulWidget {
  final List<TaskEntity> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<void> refreshData() async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } catch (error) {
      print('Refresh error: $error');
    }
  }

  final today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: widget.tasks.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TaskRow(
            isCompleted: widget.tasks[index].isCompleted,
            onToggle: () {
              setState(() {
                widget.tasks[index] = widget.tasks[index].copyWith(
                  isCompleted: !widget.tasks[index].isCompleted,
                );
              });
              final updatedTask = widget.tasks[index];

              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).updateTask(UpdateTaskParams(task: updatedTask));

              Future.delayed(Duration(seconds: 3), refreshData);
            },
            onDelete: () {
              final taskId = widget.tasks[index].id;
              setState(() {
                widget.tasks.removeAt(index);
              });
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).deleteTask(DeleteTaskParams(taskId: taskId));
            },
            title: widget.tasks[index].title,
            timeInterval: widget.tasks[index].isCompleted
                ? ''
                : '${widget.tasks[index].startTime.toString().substring(11, 16)} - ${widget.tasks[index].endTime.toString().substring(11, 16)}',
          );
        },
      ),
    );
  }
}
