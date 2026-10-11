import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/services/seed_data.dart';
import 'package:project_task_tracker/services/storage_service.dart';
import 'package:project_task_tracker/utils/form_validation.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  String searchQuery = '';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _showAddMemberDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Team Member'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter member name',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateAddMemberName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    hintText: 'Enter member role',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateAddMemberRole,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF1E4ED8)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                final newMember = Member(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: _nameController.text.trim(),
                  role: _roleController.text.trim(),
                );

                try {
                  await DatabaseHelper.instance.insertMember(newMember);

                  if (!mounted) return;

                  setState(() {
                    seedMembers.add(newMember);
                  });

                  _nameController.clear();
                  _roleController.clear();

                  Navigator.pop(dialogContext);
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Could not add team member: $e')),
                  );
                }
              },
              child: const Text(
                'Add Member',
                style: TextStyle(color: Color(0xFF1E4ED8)),
              ),
            ),
          ],
        );
      },
    );
  }

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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
        backgroundColor: const Color.fromRGBO(30, 78, 216, 1),
        onPressed: _showAddMemberDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
