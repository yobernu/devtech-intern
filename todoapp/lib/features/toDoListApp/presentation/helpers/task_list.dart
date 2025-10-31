import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class TaskList extends StatefulWidget {
  final List<TaskEntity> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
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
            },
            onDelete: () {
              // Get the task ID before removing it
              final taskId = widget.tasks[index].id;
              setState(() {
                widget.tasks.removeAt(index);
              });
              // Delete from Firebase after updating the UI
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).deleteTask(DeleteTaskParams(taskId: taskId));
            },
            title: widget.tasks[index].title,
            timeInterval:
                '${widget.tasks[index].startTime.toString().substring(11, 16)} - ${widget.tasks[index].endTime.toString().substring(11, 16)}',
          );
        },
      ),
    );
  }
}
