import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../auth/screens/login_screen.dart';
import '../home/screens/main_screen.dart';
import '../../utils/responsive_utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              isAuthenticated ? const MainScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 80,
      tablet: 120,
      desktop: 150,
    );

    final textSize = ResponsiveUtils.fontSize(context, 32);
    final spacingLarge = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 40,
      tablet: 60,
      desktop: 80,
    );

    final spacingMedium = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 20,
      tablet: 30,
      desktop: 40,
    );

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.connect_without_contact,
              size: iconSize,
              color: Colors.white,
            ),
            SizedBox(height: spacingMedium),
            Text(
              'Social Feed',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: spacingLarge),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
