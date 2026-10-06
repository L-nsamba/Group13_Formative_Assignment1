import 'package:flutter/material.dart';

class CreateEditTaskScreen extends StatefulWidget {
  const CreateEditTaskScreen({super.key});

  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  String? selectedStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              const Text(
                'Task Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Task Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

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

              const SizedBox(height: 20),

              // Priority
              const Text(
                'Priority',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 121, 248, 187),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Low',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8.0),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 241, 103),
                        border: Border.all(
                          color: Colors.yellowAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Medium',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8.0),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 104, 104),
                        border: Border.all(color: Colors.redAccent, width: 1.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'High',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Date Picker
              const Text(
                'Date Picker',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8.0),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.date_range_outlined, color: Color((0xFF1E4ED8))),
                    SizedBox(width: 10),
                    Text(
                      'Pick a due date',
                      style: TextStyle(color: Colors.black),
                    ),
                    Spacer(),
                  ],
                ),
              ),

              SizedBox(height: 20.0),
              // Assign To
              const Text(
                'Assign To',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8.0),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF1E4ED8)),
                    SizedBox(width: 10),
                    Text(
                      'Select member',
                      style: TextStyle(color: Colors.black),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  ],
                ),
              ),

              SizedBox(height: 20.0),
              // Status
              const Text(
                'Status',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8.0),

              RadioGroup<String>(
                groupValue: selectedStatus,
                onChanged: (String? value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('On Track'),
                            value: 'On Track',
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4),
                            dense: true,
                          ),
                        ),

                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('At Risk'),
                            value: 'At Risk Track',
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text('Overdue'),
                            value: 'Overdue',
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4),
                            dense: true,
                          ),
                        ),

                        Expanded(
                          child: RadioListTile(
                            title: Text('Completed'),
                            value: 'Completed',
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E4ED8),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
