import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/task_list.dart';
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

class MainTaskScreen extends StatefulWidget {
  final VoidCallback onMenuPressed;
  const MainTaskScreen({required this.onMenuPressed, super.key});

  @override
  State<MainTaskScreen> createState() => _MainTaskScreenState();
}

class _MainTaskScreenState extends State<MainTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialTasks();
    });
  }

  Future<void> _loadInitialTasks() async {
    try {
      EasyLoading.show(status: 'Loading your tasks...');
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.showError('Failed to load tasks');
    }
  }

  Future<void> refreshData() async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } catch (error) {
      EasyLoading.showError('Refresh failed');
    }
  }

  void _handleError(String? errorMessage) {
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        if (taskProvider.errorMessage != null) {
          _handleError(taskProvider.errorMessage);
        }

        final waitingTasks = taskProvider.tasks
            .where((task) => !task.isCompleted)
            .toList();

        if (taskProvider.tasks.isEmpty && !taskProvider.isLoading) {
          return _buildScaffold(body: const Newuser(), showFAB: true);
        }

        return _buildScaffold(
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchBox(),
                  const SizedBox(height: 16),
                  if (waitingTasks.isEmpty && !taskProvider.isLoading)
                    _buildNoPendingTasks()
                  else
                    TaskList(tasks: waitingTasks),
                ],
              ),
            ),
          ),
          showFAB: true,
        );
      },
    );
  }

  Widget _buildScaffold({required Widget body, required bool showFAB}) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF466A5E),
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontFamily: 'preahvihear',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_sharp, color: Colors.white),
          onPressed: widget.onMenuPressed,
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: body),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () => _showAddTaskModal(context),
              backgroundColor: const Color(0xFF466A5E),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  Widget _buildNoPendingTasks() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: const Color(0xFF466A5E).withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'All tasks completed!',
              style: TextStyle(
                fontFamily: 'preahvihear',
                fontSize: 20,
                color: const Color(0xFF466A5E),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add new tasks using the + button below',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'preahvihear',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    try {
      showModal(context);
    } catch (error) {
      EasyLoading.showError('Failed to open task form');
    }
  }
}
// taskrow

