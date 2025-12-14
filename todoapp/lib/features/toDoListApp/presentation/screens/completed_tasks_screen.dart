import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/update_task.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/task_list_screen.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

// update
class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  Future<void> _refreshTasks() async {
    try {
      await Provider.of<TaskProvider>(
        context,
        listen: false,
      ).fetchCompletedTasks();
    } catch (error) {
      print('Refresh error: $error');
      _showErrorSnackBar('Failed to refresh tasks: $error');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _handleToggleTask(TaskEntity task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      // Update the task
      await taskProvider.updateTaskItem(updatedTask);

      // Refresh both tasks and completed tasks
      await Future.wait([
        taskProvider.fetchTasks(),
        taskProvider.fetchCompletedTasks(),
      ]);

      _showSuccessSnackBar('Task updated successfully');
    } catch (error) {
      _showErrorSnackBar('Failed to update task: $error');
    }
  }

  Future<void> _handleDeleteTask(TaskEntity task, int index) async {
    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      // Delete the task
      await taskProvider.deleteTaskItem(task.id);

      // Refresh both tasks and completed tasks
      await Future.wait([
        taskProvider.fetchTasks(),
        taskProvider.fetchCompletedTasks(),
      ]);

      _showSuccessSnackBar('Task deleted successfully');
    } catch (error) {
      _showErrorSnackBar('Failed to delete task: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchCompletedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TaskListScreen()),
          ),
        ),
        title: const Text(
          'Completed Tasks',
          style: TextStyle(
            fontFamily: 'preahvihear',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          // Get completed tasks here
          final completedTasks = taskProvider.completedTasks;

          if (taskProvider.isLoading) {
            return _buildGradientBackground(
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          // Check if we have any completed tasks
          if (completedTasks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: _buildGradientBackground(
              child: SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return TaskRow(
                      key: ValueKey(task.id),
                      title: task.title,
                      description: task.description ?? '',
                      timeInterval: task.endTime != null
                          ? 'Ends: ${_formatDateTime(task.endTime!)}'
                          : 'No end time',
                      isCompleted: task.isCompleted,
                      category: task.category,
                      priority: task.priority,
                      dueDate: task.dueDate,
                      onToggle: () => _handleToggleTask(task),
                      onDelete: () => _handleDeleteTask(task, index),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildGradientBackground({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF37584E)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildEmptyState() {
    return _buildGradientBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 24),
              Text(
                'No completed tasks yet',
                style: TextStyle(
                  fontFamily: 'preahvihear',
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Once you finish your tasks, they\'ll appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'preahvihear',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
