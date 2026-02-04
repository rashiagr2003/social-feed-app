import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/responsive_utils.dart';
import '../../home/screens/main_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .signUp(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              _nameController.text.trim(),
            );

        final isAuth = ref.read(isAuthenticatedProvider);
        if (mounted && isAuth) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email already exists. Please login.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Sign up failed')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Responsive values
    final padding = ResponsiveUtils.responsivePadding(context);
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 80.0,
      tablet: 100.0,
      desktop: 120.0,
    );
    final fontLarge = ResponsiveUtils.fontSize(context, 28);
    final fontMedium = ResponsiveUtils.fontSize(context, 16);
    final buttonHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: 50.0,
      tablet: 55.0,
      desktop: 60.0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: padding,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: iconSize,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: padding.top / 2),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: fontLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join our community today',
                    style: TextStyle(
                      fontSize: fontMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your name'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter email'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter password';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),

                  // Error Message
                  if (authState.error != null) ...[
                    SizedBox(height: 16),
                    Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                  SizedBox(height: 24),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Sign Up',
                              style: TextStyle(fontSize: fontMedium),
                            ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Google Sign-Up Button
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: OutlinedButton.icon(
                      icon: Image.network(
                        'https://dospace.org/wp-content/uploads/2018/01/Google_logo.jpg',
                        height: 24,
                        width: 24,
                      ),
                      label: Text(
                        'Sign up with Google',
                        style: TextStyle(
                          fontSize: fontMedium,
                          color: Colors.black87,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signInWithGoogle();
                              final isAuth = ref.read(isAuthenticatedProvider);
                              if (mounted && isAuth) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const MainScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: fontMedium),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: fontMedium),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
