import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary dark blue matching your palette
    const Color darkBlue = Color(0xFF1E4ED8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light canvas background
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        centerTitle: true,
        // I think it is okay if we remove menu icon, I don't see its importance
        /*leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Can open a drawer or show navigation
          },
        )*/
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // 3. User Avatar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF3B82F6), // Lighter blue accent
              child: const Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Task List UI coming next...'),
      ),
      // Floating Action Button for task creation
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        onPressed: () async {
          await Navigator.pushNamed(context, '/create-edit');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}