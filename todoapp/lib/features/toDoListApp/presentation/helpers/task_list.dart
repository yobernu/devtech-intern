import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
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
      padding: const EdgeInsets.only(top: 32),
      child: ListView.builder(
        itemCount: widget.tasks.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TaskRow(
            title: widget.tasks[index].title,
            timeInterval:
                '${widget.tasks[index].startTime.toString()} - ${widget.tasks[index].endTime.toString()}',
          );
        },
      ),
    );
  }
}
