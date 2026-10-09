import 'package:flutter/material.dart';
import 'package:project_task_tracker/services/seed_data.dart';

class TeamMembersScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E4ED8),
        title: const Text(
          'Team Members',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400), 
        ),
        centerTitle: true,
        // backgroundColor: Color((0xFF1E4ED8)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
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
              child: ListView.builder(
                itemCount: seedMembers.length,
                itemBuilder: (context, index) {
                  final Member = seedMembers[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 135, 178, 252),
                      child: Text(Member.name.substring(0, 2).toUpperCase(), style: TextStyle(color: Colors.black),),
                    ),
                    title: Text(Member.name),
                    subtitle: Text(Member.role),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add),),
    );
  }
}
