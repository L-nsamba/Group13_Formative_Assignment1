import 'package:flutter/material.dart';
import 'package:project_task_tracker/theme/app_theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 66.0, right: 16.0),
      child: Divider(height: 1, thickness: 1, color: AppColors.border),
    );
  }
}