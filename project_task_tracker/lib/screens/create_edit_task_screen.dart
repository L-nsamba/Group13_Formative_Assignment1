import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/utils/form_validation.dart';
import 'package:project_task_tracker/models/task.dart';

import '../widgets/assign_to_widget.dart';

class CreateEditTaskScreen extends StatefulWidget {
  final Task? task;
  const CreateEditTaskScreen({
    super.key,
    this.task,
    });


  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  String? selectedStatus;
  String? statusError;
  String? selectedPriority;
  String? priorityError;
  Member? selectedMember;
  String? assigneeError;
  DateTime? _selectedDate;
  String? dueDateError;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title
                const Text(
                  'Task Title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  validator: Validators.validateTaskTitle,
                  decoration: InputDecoration(
                    hintText: 'Enter Task Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25.0),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                TextField(
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter a description',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25.0),

                // Priority
                const Text(
                  'Priority',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPriority = 'Low';
                            priorityError = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: selectedPriority == 'Low'
                                ? const Color.fromARGB(255, 121, 248, 187)
                                : const Color.fromARGB(255, 220, 250, 232),
                            border: Border.all(
                              color: selectedPriority == 'Low'
                                  ? Colors.green
                                  : Colors.greenAccent,
                              width: selectedPriority == 'Low' ? 2.5 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedPriority == 'Low')
                                const Icon(Icons.check, size: 18),
                              if (selectedPriority == 'Low')
                                const SizedBox(width: 4),

                              Text(
                                'Low',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8.0),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPriority = 'Medium';
                            priorityError = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: selectedPriority == 'Medium'
                                ? const Color.fromARGB(255, 241, 241, 103)
                                : Color.fromARGB(255, 238, 255, 169),
                            border: Border.all(
                              color: selectedPriority == 'Medium'
                                  ? Colors.yellow
                                  : Colors.yellowAccent,
                              width: selectedPriority == 'Medium' ? 2.5 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedPriority == 'Medium')
                                const Icon(Icons.check, size: 18),
                              if (selectedPriority == 'Medium')
                                const SizedBox(width: 4),

                              const Text(
                                'Medium',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8.0),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPriority = 'High';
                            priorityError = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: selectedPriority == 'High'
                                ? const Color.fromARGB(255, 254, 104, 104)
                                : const Color.fromARGB(255, 255, 222, 225),
                            border: Border.all(
                              color: selectedPriority == 'High'
                                  ? Colors.red
                                  : Colors.redAccent,
                              width: selectedPriority == 'High' ? 2.5 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedPriority == 'High')
                                const Icon(Icons.check, size: 18),

                              if (selectedPriority == 'High')
                                const SizedBox(width: 4),
                              const Text(
                                'High',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (priorityError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    priorityError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 25.0),

                // Date Picker
                const Text(
                  'Due Date',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8.0),

                OutlinedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2035),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: const TextScaler.linear(0.9)),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        dueDateError = null;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color((0xFF1E4ED8)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? 'Select due date'
                            : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                                  '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                                  '${_selectedDate!.year}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                if (dueDateError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    dueDateError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                SizedBox(height: 25.0),
                // Assign To
                const Text(
                  'Assign To',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8.0),

                OutlinedButton(
                  onPressed: () async {
                    final member = await showDialog<Member?>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: MemberSelectionCard(
                            selectedMember: selectedMember,
                          ),
                        );
                      },
                    );

                    if (!mounted) return;

                    if (member != null) {
                      setState(() {
                        selectedMember = member;
                        assigneeError = null;
                      });
                    }
                  },

                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF1E4ED8)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedMember?.name ?? 'Selected member',
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      if (selectedMember != null)
                        IconButton(
                          alignment: Alignment.centerRight,
                          icon: const Icon(Icons.close),
                          tooltip: 'Clear assigned member',
                          onPressed: () {
                            setState(() {
                              selectedMember = null;
                            });
                          },
                        )
                      else
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),

                if (assigneeError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    assigneeError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                SizedBox(height: 50.0),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E4ED8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final isFormValid = _formKey.currentState!.validate();

                      setState(() {
                        priorityError = selectedPriority == null
                            ? 'Please select a priority'
                            : null;

                        dueDateError = _selectedDate == null
                            ? 'Please select a due data'
                            : null;

                        assigneeError = selectedMember == null
                            ? 'Please select a team member'
                            : null;

                        statusError = selectedStatus == null
                            ? 'Please select a status'
                            : null;
                      });

                      if (!isFormValid ||
                          selectedPriority == null ||
                          _selectedDate == null ||
                          selectedMember == null ||
                          selectedStatus == null) {
                        return;
                      }
                    },
                    child: const Text('Create Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
