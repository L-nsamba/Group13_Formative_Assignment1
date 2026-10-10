import 'package:flutter/material.dart';
import 'package:project_task_tracker/screens/create_edit_task_screen.dart';
import 'package:project_task_tracker/screens/main_shell.dart';
import 'package:project_task_tracker/screens/member_profile_screen.dart';
import 'package:project_task_tracker/screens/sign_in_screen.dart';
import 'package:project_task_tracker/screens/task_details_screen.dart';
import 'package:project_task_tracker/screens/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home' , //sign-in
      routes: {
        // '/sign-in': (_) => const SignInScreen(),
        '/home': (_) => const MainShell(),
        //'/task-details': (_) => const TaskDetailsScreen(),
        '/create-edit': (_) => const CreateEditTaskScreen(),
        '/member-profile': (_) => const MemberProfileScreen(),
        '/view-tasks':(_)=> const TaskListScreen()
      },
    );
  }
}
