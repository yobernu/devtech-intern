import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/mycalendar_datasource.dart';
import 'package:todoapp/features/toDoListApp/presentation/helpers/title_input.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/features/toDoListApp/presentation/widgets/custom_button.dart';

void showModal(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<PickerDateRange> selectedRanges = [];
  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTime;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext modalContext) {
      return ChangeNotifierProvider.value(
        value: Provider.of<TaskProvider>(context, listen: false),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Task',
                  style: Theme.of(modalContext).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TitleInput(
                  controller: titleController,
                  label: 'Task Title',
                  icon: const Icon(Icons.title),
                ),
                TitleInput(
                  controller: descriptionController,
                  label: 'Task Description',
                  icon: const Icon(Icons.description),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 16),
                    Text(
                      "Calendar",
                      style: Theme.of(modalContext).textTheme.bodyLarge,
                    ),
                  ],
                ),
                SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.multiRange,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) async {
                        selectedRanges = args.value;
                        for (var range in selectedRanges) {
                          TimeOfDay? startTime = await showTimePicker(
                            context: modalContext,
                            initialTime: const TimeOfDay(hour: 9, minute: 0),
                          );

                          TimeOfDay? endTime = await showTimePicker(
                            context: modalContext,
                            initialTime: const TimeOfDay(hour: 17, minute: 0),
                          );

                          if (startTime != null &&
                              endTime != null &&
                              range.startDate != null &&
                              range.endDate != null) {
                            selectedStartDateTime = DateTime(
                              range.startDate!.year,
                              range.startDate!.month,
                              range.startDate!.day,
                              startTime.hour,
                              startTime.minute,
                            );

                            selectedEndDateTime = DateTime(
                              range.endDate!.year,
                              range.endDate!.month,
                              range.endDate!.day,
                              endTime.hour,
                              endTime.minute,
                            );

                            print(
                              'Selected range: $selectedStartDateTime to $selectedEndDateTime',
                            );
                          }
                        }
                      },
                ),
                const SizedBox(height: 48),
                CustomButton(
                  title: 'Add Task',
                  prefIcon: const Icon(Icons.add),
                  onPress: () {
                    if (selectedStartDateTime == null || selectedEndDateTime == null) {
                      ScaffoldMessenger.of(modalContext).showSnackBar(
                        const SnackBar(content: Text('Please select both start and end times')),
                      );
                      return;
                    }
                    
                    final task = TaskEntity(
                      id: UniqueKey().toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      isCompleted: false,
                      createdAt: DateTime.now(),
                      startTime: selectedStartDateTime!,
                      endTime: selectedEndDateTime!,
                    );

                    final provider = Provider.of<TaskProvider>(
                      modalContext,
                      listen: false,
                    );
                    provider.createTask(task);
                    Navigator.pop(modalContext);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
