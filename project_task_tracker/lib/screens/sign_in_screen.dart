import 'package:flutter/material.dart';
import 'package:project_task_tracker/theme/app_theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'jean.uwimana@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? true) {
      setState(() => _isLoading = true);
      
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate directly to Member Profile screen
      Navigator.of(context).pushReplacementNamed('/member-profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                
                // Milo Logo Header
                const _MiloLogoHeader(),
                
                const SizedBox(height: 28),
                
                // Main Title & Subtitle
                const Text(
                  'Good to see you\nagain.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sign in to your account and pick up right where you left off.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Email Field Label
                const Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Email TextFormField
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Password Field Label
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Password TextFormField
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 10),
                
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset link sent to your email.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sign In Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Divider: "or continue with"
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: AppColors.border,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.border,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Social Login Buttons (Apple & Google)
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        iconWidget: const Icon(
                          Icons.apple,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                        label: 'Apple',
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/member-profile');
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SocialButton(
                        iconWidget: const _GoogleGIcon(),
                        label: 'Google',
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/member-profile');
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 36),
                
                // Create Account Prompt Footer
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirecting to Registration flow...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(text: 'New to milo? '),
                          TextSpan(
                            text: 'Create an account',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 28),
                
                // Privacy / Safety Badge Footer
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 15,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Your information stays safe and private.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Milo Logo Header Widget: Blue Rounded Container with stylized 'm' + text 'milo'
class _MiloLogoHeader extends StatelessWidget {
  const _MiloLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(20, 18),
              painter: _MiloLogoPainter(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'milo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the Milo 'm' twin-arch logo
class _MiloLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Draw twin arch 'm' symbol
    final w = size.width;
    final h = size.height;
    
    path.moveTo(0, h * 0.95);
    path.lineTo(0, h * 0.45);
    path.cubicTo(0, h * 0.05, w * 0.42, h * 0.05, w * 0.48, h * 0.45);
    path.lineTo(w * 0.48, h * 0.95);
    
    final path2 = Path();
    path2.moveTo(w * 0.48, h * 0.45);
    path2.cubicTo(w * 0.48, h * 0.05, w * 0.98, h * 0.05, w * 0.98, h * 0.45);
    path2.lineTo(w * 0.98, h * 0.95);

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Social Button Component
class _SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Google Multi-Color 'G' Icon
class _GoogleGIcon extends StatelessWidget {
  const _GoogleGIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleGPainter(),
      ),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Blue segment
    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
      
    // Green segment
    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    // Yellow segment
    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;

    // Red segment
    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Draw stylized G using colored arcs & bar
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Red top arc
    canvas.drawArc(rect, -2.2, 1.8, true, redPaint);
    
    // Yellow left arc
    canvas.drawArc(rect, -3.8, 1.6, true, yellowPaint);
    
    // Green bottom arc
    canvas.drawArc(rect, 0.4, 1.8, true, greenPaint);

    // Blue right arc & bar
    canvas.drawArc(rect, -0.6, 1.0, true, bluePaint);

    // Inner white cutout circle
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.58, innerPaint);

    // Blue horizontal bar
    final barRect = Rect.fromLTWH(w * 0.45, h * 0.38, w * 0.55, h * 0.24);
    canvas.drawRect(barRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
