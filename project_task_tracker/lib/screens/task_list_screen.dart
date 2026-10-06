import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Center(child: Text('Task List Screen in progress....')),


      // On clicked this button will take you to the create task screen
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/create-edit');
        },
        child: const Icon(Icons.add),
        // _loadTask() add eventually to sync newly created / edited tasks
      ),
    );
  }
}
