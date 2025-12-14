import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/core/constants/app_constants.dart';
import 'package:todoapp/core/theme/app_theme.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/completed_tasks_screen.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/add_edit_task_dialog.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/category_chip.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/empty_state.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/search_box.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/statistics_card.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/task_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final tabs = ['All', 'Active', 'Completed'];
        Provider.of<TaskProvider>(
          context,
          listen: false,
        ).setTab(tabs[_tabController.index]);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEditTaskDialog(BuildContext context, [TaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditTaskDialog(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            final stats = provider.statistics;
            final tasks = provider.filteredTasks;

            return CustomScrollView(
              slivers: [
                // App Bar & Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, Friend! 👋',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Let\'s be productive today',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.history,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CompletedTasksScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SearchBox(), // Note: SearchBox needs update to use provider
                      ],
                    ),
                  ),
                ),

                // Statistics Card
                SliverToBoxAdapter(
                  child: StatisticsCard(
                    totalTasks: stats.totalTasks,
                    completedTasks: stats.completedTasks,
                  ),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        CategoryChip(
                          category: 'All',
                          isSelected: _selectedCategory == 'All',
                          onTap: () {
                            setState(() => _selectedCategory = 'All');
                            provider.setCategoryFilter(null);
                          },
                        ),
                        ...AppConstants.categories.map((category) {
                          return CategoryChip(
                            category: category,
                            isSelected: _selectedCategory == category,
                            onTap: () {
                              setState(() => _selectedCategory = category);
                              provider.setCategoryFilter(category);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Tabs
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Active'),
                        Tab(text: 'Done'),
                      ],
                    ),
                  ),
                ),

                // Task List
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (tasks.isEmpty)
                  SliverFillRemaining(
                    child: EmptyState(
                      message: 'No tasks found',
                      subMessage:
                          'Try adjusting your filters or create a new task',
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final task = tasks[index];
                      return TaskRow(
                        title: task.title,
                        description: task.description ?? '',
                        timeInterval: task.dueDate != null
                            ? '${task.dueDate!.day}/${task.dueDate!.month} ${task.dueDate!.hour}:${task.dueDate!.minute.toString().padLeft(2, '0')}'
                            : '',
                        isCompleted: task.isCompleted,
                        category: task.category,
                        priority: task.priority,
                        dueDate: task.dueDate,
                        onToggle: () {
                          final updatedTask = task.copyWith(
                            isCompleted: !task.isCompleted,
                          );
                          provider.updateTaskItem(updatedTask);
                        },
                        onDelete: () {
                          provider.deleteTaskItem(task.id);
                        },
                        onEdit: () => _showAddEditTaskDialog(context, task),
                      );
                    }, childCount: tasks.length),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.fabGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4C6C63FF),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddEditTaskDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
