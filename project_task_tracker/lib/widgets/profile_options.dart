import 'package:flutter/material.dart';
import 'package:project_task_tracker/theme/app_theme.dart';

/// Custom Option Tile for Profile List Items
class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailingWidget;
  final String? trailingText;
  final VoidCallback? onTap;

  const ProfileOptionTile({
    required this.icon,
    required this.title,
    this.trailingWidget,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Blue tinted icon background container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 135, 178, 252),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Trailing Widget / Arrow / Text
            if (trailingWidget != null)
              trailingWidget!
            else if (trailingText != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ],
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
