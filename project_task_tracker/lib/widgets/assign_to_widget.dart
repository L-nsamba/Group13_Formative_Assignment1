import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/services/seed_data.dart';

class MemberSelectionCard extends StatefulWidget {
  const MemberSelectionCard({super.key, Member? selectedMember});

  @override
  State<MemberSelectionCard> createState() => _MemberSelectionCardState();
}

class _MemberSelectionCardState extends State<MemberSelectionCard> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final tasks = buildSeedTasks();

    final availableMembers = seedMembers.where((member) {
      final assignedTasks = tasks
          .where((task) => task.assigneeId == member.id)
          .toList();

      final hasNoUnfinishedTasks = assignedTasks.every(
        (task) => task.isCompleted,
      );

      return hasNoUnfinishedTasks;
    }).toList();

    final filteredMembers = availableMembers.where((Member) {
      final name = Member.name.toLowerCase();
      final role = Member.role.toLowerCase();
      final query = searchQuery.toLowerCase();

      return name.contains(query) || role.contains(query);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height *
            0.45, // Controlling how much of the screen the card occupies
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign To',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 16),

            // Search field
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Member List
            Expanded(
              child: filteredMembers.isEmpty
                  ? const Center(child: Text('No members found'))
                  : ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE3F2FD),
                            child: Text(
                              member.name.substring(0, 2).toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.role),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(context, member);
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('Clear selection'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
