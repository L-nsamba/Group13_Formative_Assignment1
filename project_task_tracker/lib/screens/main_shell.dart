import 'package:flutter/material.dart';
import 'package:project_task_tracker/screens/member_profile_screen.dart';

import 'dashboard_screen.dart';
import 'task_list_screen.dart';
import 'team_members_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    TaskListScreen(),
    TeamMembersScreen(),
    MemberProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _index = index;
    });

    if (index == 1) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF1E4ED8),
        currentIndex: _index,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
