import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/task_list.dart';
import 'package:todoapp/features/toDoListApp/presentation/navigation.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/drawer_screen.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/show_modal.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/new_user.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/search_box.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      borderRadius: 30.0,
      showShadow: true,
      angle: -8.0,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.easeInOut,
      mainScreenTapClose: true,
      menuBackgroundColor: const Color(0xFF466A5E),
      mainScreen: MainTaskScreen(
        onMenuPressed: () => zoomDrawerController.toggle!(),
      ),
      menuScreen: const CustomDrawer(),
    );
  }
}

// =======================================================
// ✅ Main Screen (Tasks, AppBar, etc.)
// =======================================================
class MainTaskScreen extends StatefulWidget {
  final VoidCallback onMenuPressed;
  const MainTaskScreen({required this.onMenuPressed, super.key});

  @override
  State<MainTaskScreen> createState() => _MainTaskScreenState();
}

class _MainTaskScreenState extends State<MainTaskScreen> {
  Future<void> refreshData() async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } catch (error) {
      print('Refresh error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF466A5E),
        title: const Text(
          'Simple To-Do App',
          style: TextStyle(fontFamily: 'preahvihear'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final waitingTasks = taskProvider.tasks
              .where((task) => !task.isCompleted)
              .toList();
          final completedTasks = taskProvider.tasks
              .where((task) => task.isCompleted)
              .toList();
          if (taskProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(taskProvider.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              taskProvider.errorMessage = null;
            });
          }

          if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFF37584E)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (taskProvider.tasks.isEmpty) {
            return const Newuser();
          }

          return RefreshIndicator(
            onRefresh: refreshData,
            child: Column(
              children: [
                const SearchBox(),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: waitingTasks.length,
                    itemBuilder: (context, index) {
                      return TaskList(tasks: [waitingTasks[index]]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModal(context),
        backgroundColor: const Color(0xFF466A5E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}



// completed