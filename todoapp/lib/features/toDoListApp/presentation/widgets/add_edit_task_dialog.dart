import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/core/constants/app_constants.dart';
import 'package:todoapp/core/theme/app_theme.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/category_chip.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_button.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/title_input.dart';

class AddEditTaskDialog extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskDialog({super.key, this.task});

  @override
  State<AddEditTaskDialog> createState() => _AddEditTaskDialogState();
}

class _AddEditTaskDialogState extends State<AddEditTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _selectedCategory = AppConstants.categoryPersonal;
  String _selectedPriority = AppConstants.priorityMedium;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    if (widget.task != null) {
      _selectedCategory = widget.task!.category;
      _selectedPriority = widget.task!.priority;
      _selectedDate = widget.task!.dueDate;
      if (widget.task!.startTime != null) {
        _startTime = TimeOfDay.fromDateTime(widget.task!.startTime!);
      }
      if (widget.task!.endTime != null) {
        _endTime = TimeOfDay.fromDateTime(widget.task!.endTime!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_endTime ?? const TimeOfDay(hour: 17, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.task == null ? 'New Task' : 'Edit Task',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleInput(
                    controller: _titleController,
                    label: 'Task Title',
                    icon: const Icon(Icons.title),
                  ),
                  const SizedBox(height: 16),
                  TitleInput(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: const Icon(Icons.description_outlined),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppConstants.categories.map((category) {
                        return CategoryChip(
                          category: category,
                          isSelected: category == _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Priority',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: AppConstants.priorities.map((priority) {
                      final isSelected = priority == _selectedPriority;
                      final color =
                          AppConstants.priorityColors[priority] ?? Colors.grey;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withOpacity(0.2)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  AppConstants.priorityIcons[priority],
                                  color: isSelected ? color : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  priority.toUpperCase(),
                                  style: TextStyle(
                                    color: isSelected ? color : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Schedule',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeButton(
                          context,
                          'Date',
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                          Icons.calendar_today,
                          () => _selectDate(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeButton(
                          context,
                          'Start Time',
                          _startTime?.format(context) ?? 'Select',
                          Icons.access_time,
                          () => _selectTime(context, true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimeButton(
                          context,
                          'End Time',
                          _endTime?.format(context) ?? 'Select',
                          Icons.access_time_filled,
                          () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            title: widget.task == null ? 'Create Task' : 'Update Task',
            prefIcon: Icon(widget.task == null ? Icons.add : Icons.save),
            onPress: _saveTask,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final now = DateTime.now();
    DateTime? startDateTime;
    DateTime? endDateTime;

    if (_selectedDate != null) {
      if (_startTime != null) {
        startDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }
      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }
    }

    final task = TaskEntity(
      id: widget.task?.id ?? UniqueKey().toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? now,
      updatedAt: now,
      category: _selectedCategory,
      priority: _selectedPriority,
      dueDate: _selectedDate,
      startTime: startDateTime,
      endTime: endDateTime,
    );

    final provider = Provider.of<TaskProvider>(context, listen: false);
    if (widget.task == null) {
      provider.createTask(task);
    } else {
      provider.updateTaskItem(task);
    }

    Navigator.pop(context);
  }
}
