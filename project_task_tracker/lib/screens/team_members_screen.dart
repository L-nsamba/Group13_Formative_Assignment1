import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/services/seed_data.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final filteredMembers = seedMembers.where((member) {
      final name = member.name.toLowerCase();
      final role = member.role.toLowerCase();
      final query = searchQuery.toLowerCase();

      return name.contains(query) || role.contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E4ED8),
        title: const Text(
          'Team Members',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        // backgroundColor: Color((0xFF1E4ED8)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search members',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: filteredMembers.isEmpty
                  ? const Center(child: Text('No members found'))
                  : ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromARGB(
                              255,
                              135,
                              178,
                              252,
                            ),
                            child: Text(
                              member.name.substring(0, 2).toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.role),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
