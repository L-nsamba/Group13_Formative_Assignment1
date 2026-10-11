import 'package:flutter/material.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/theme/app_theme.dart';
import 'package:project_task_tracker/widgets/custom_divider.dart';
import 'package:project_task_tracker/widgets/profile_options.dart';
import 'package:project_task_tracker/widgets/user_profile_card.dart';

class MemberProfileScreen extends StatefulWidget {
  final Member? member;

  const MemberProfileScreen({super.key, this.member});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final routeMember = ModalRoute.of(context)?.settings.arguments as Member?;
    final member = widget.member ?? routeMember;

    final name = member?.name ?? 'Unknown User';
    final roleOrEmail = member != null
        ? '${member.name.toLowerCase().replaceAll(' ', '.')}@gmail.com'
        : 'unknown@gmail.com';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        backgroundColor: Color(0xFF1E4ED8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          textAlign: TextAlign.center,
          'My profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header with initials + email
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 28.0),
                    child: UserProfileHeaderCard(
                      name: member?.name ?? 'Unknown User',
                      email: member != null
                          ? '${member.name.toLowerCase().replaceAll(' ', '.')}@gmail.com'
                          : 'unknown@gmail.com',
                    ),
                  ),

                  // ACCOUNT Section Header
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'ACCOUNT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // ACCOUNT Section Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        ProfileOptionTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal information',
                          onTap: () {},
                        ),
                        const CustomDivider(),
                        ProfileOptionTile(
                          icon: Icons.wb_sunny_outlined,
                          title: 'Appearance',
                          trailingWidget: Switch.adaptive(
                            value:
                                Theme.of(context).brightness ==
                                Brightness.light,
                            activeTrackColor: AppColors.primary,
                            onChanged: (val) {
                              print('Appearance toggled: $val');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sign out button pinned near bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/sign-in'),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sign out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/sign-in');
              },
            ),
          ],
        ),
      ),
    );
  }
}

