import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class CompletedTasksScreen extends StatelessWidget {
  final List<Map<String, dynamic>> completedTasks;

  const CompletedTasksScreen({Key? key, required this.completedTasks})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF17D092), Color(0xFF0B6E4F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: completedTasks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return TaskRow(
                      title: task['title'],
                      timeInterval: task['timeInterval'],
                      isCompleted: true,
                      onToggle: () {
                        // You could handle un-completing a task here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task marked as incomplete'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onDelete: () {
                        // Delete handler placeholder
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// Displays a nice visual when there are no completed tasks
  Widget _buildEmptyState() {
    return Center(
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
              'Once you finish your tasks, they’ll appear here.',
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
    );
  }
}
