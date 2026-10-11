import 'package:flutter/material.dart';
import 'package:project_task_tracker/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: AppColors.textPrimary, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            const Text(
              'Project progress',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            
            const SizedBox(height: 20),

            // Northstar launch Project Card
            const _NorthstarLaunchCard(),

            const SizedBox(height: 28),

            // Focus Areas Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Focus areas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary, size: 22),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/view-tasks');
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Focus Areas Grid (Design & QA)
            Row(
              children: const [
                Expanded(
                  child: _FocusAreaCard(
                    title: 'Design',
                    percentage: '82%',
                    progressValue: 0.82,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _FocusAreaCard(
                    title: 'QA',
                    percentage: '61%',
                    progressValue: 0.61,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Recent Updates Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent updates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary, size: 22),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recent Updates List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  _RecentUpdateItem(
                    title: 'Design review',
                    description: 'Approved hero screens and updated the navigation spec.',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1, thickness: 1, color: AppColors.border),
                  ),
                  _RecentUpdateItem(
                    title: 'API integration',
                    description: 'Connected auth flow and resolved the token refresh issue.',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1, thickness: 1, color: AppColors.border),
                  ),
                  _RecentUpdateItem(
                    title: 'QA blockers',
                    description: '4 open issues need attention before the next build.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: false,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            _NavBarItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              isSelected: true,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/dashboard');
              },
            ),
            _NavBarItem(
              icon: Icons.bookmark_border_rounded,
              label: 'Saved',
              isSelected: false,
              onTap: () {},
            ),
            _NavBarItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isSelected: false,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/member-profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Project Summary Card ("Northstar launch")
class _NorthstarLaunchCard extends StatelessWidget {
  const _NorthstarLaunchCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Title & On track badge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Northstar launch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'On track',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          
          // Subtitle stats
          const Text(
            '12 active tasks • 4 blockers • 3 days left',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 18),
          
          // Progress bar & percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.70,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                '70%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Completed & At risk Stats Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '14/20',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'At risk',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '4 tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Focus Area Small Card (Design / QA)
class _FocusAreaCard extends StatelessWidget {
  final String title;
  final String percentage;
  final double progressValue;

  const _FocusAreaCard({
    required this.title,
    required this.percentage,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent Update Item Tile
class _RecentUpdateItem extends StatelessWidget {
  final String title;
  final String description;

  const _RecentUpdateItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Geometric abstract icon box
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(22, 22),
              painter: _GeometricIconPainter(),
            ),
          ),
        ),
        const SizedBox(width: 14),
        
        // Text details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        
        // Options menu icon
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textSecondary),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

/// Custom painter for the abstract shapes icon (Triangle, Circle, Square)
class _GeometricIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Top Triangle
    final triPath = Path();
    triPath.moveTo(w * 0.5, h * 0.05);
    triPath.lineTo(w * 0.72, h * 0.42);
    triPath.lineTo(w * 0.28, h * 0.42);
    triPath.close();
    canvas.drawPath(triPath, paint);

    // Bottom Left Starburst / Circle
    canvas.drawCircle(Offset(w * 0.3, h * 0.72), w * 0.18, paint);

    // Bottom Right Rounded Square
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.55, h * 0.54, w * 0.36, h * 0.36),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Navigation Bar Item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
