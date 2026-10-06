import 'package:flutter/material.dart';

class CreateEditTaskScreen extends StatelessWidget {
  const CreateEditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
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
                hintText: 'Enter a description...',
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
                      color: Colors.greenAccent,
                      border: Border.all(color: Colors.greenAccent, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'Low',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
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
                      color: Colors.yellowAccent,
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
                        fontWeight: FontWeight.bold,
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
                      color: Colors.redAccent,
                      border: Border.all(color: Colors.redAccent, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'High',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
