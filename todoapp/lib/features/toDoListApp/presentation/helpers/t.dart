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
  int selectedCategoryIndex = 0;
  bool _isLoading = true;
  String? _error;

  Map<String, List<TaskEntity>> _groupTasksByCategory(List<TaskEntity> tasks) {
    final activeTasks = tasks.where((task) => !task.isCompleted).toList();

    return activeTasks.fold(<String, List<TaskEntity>>{}, (map, task) {
      final categoryName = (task.category.trim().isEmpty
          ? 'Uncategorized'
          : task.category.trim());
      final displayName =
          '${categoryName[0].toUpperCase()}${categoryName.substring(1).toLowerCase()}';

      map.putIfAbsent(displayName, () => []).add(task);
      return map;
    });
  }

  Future<void> refreshData() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      if (mounted) setState(() => _error = null);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Failed to load tasks. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refreshData());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: refreshData, child: const Text('Retry')),
          ],
        ),
      );
    }

    final groupedTasks = _groupTasksByCategory(widget.tasks);
    final categories = groupedTasks.keys.toList();

    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No active tasks yet ✨',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (selectedCategoryIndex >= categories.length) {
      selectedCategoryIndex = 0;
    }

    final tasksInCategory =
        groupedTasks[categories[selectedCategoryIndex]] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Horizontal category chips
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Category header
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              categories[selectedCategoryIndex],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Scrollable task list
          Expanded(
            child: tasksInCategory.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks in this category',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: refreshData,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tasksInCategory.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = tasksInCategory[index];
                        return TaskRow(
                          title: task.title,
                          timeInterval:
                              (task.startTime != null && task.endTime != null)
                              ? '${task.startTime.toString().substring(11, 16)} - ${task.endTime.toString().substring(11, 16)}'
                              : '',
                          isCompleted: task.isCompleted,
                          onToggle: () {
                            final updatedTask = task.copyWith(
                              isCompleted: !task.isCompleted,
                            );
                            Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).updateTask(UpdateTaskParams(task: updatedTask));
                            refreshData();
                          },
                          onDelete: () {
                            Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).deleteTask(DeleteTaskParams(taskId: task.id));
                            refreshData();
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
