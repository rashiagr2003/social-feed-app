import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../utils/responsive_utils.dart';
import '../../home/screens/main_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(_emailController.text, _passwordController.text);
      if (mounted && ref.read(isAuthenticatedProvider)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

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
                    Icons.connect_without_contact,
                    size: iconSize,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: padding.top / 2),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: fontLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: fontMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 40),
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
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter password'
                        : null,
                  ),
                  if (authState.error != null) ...[
                    SizedBox(height: 16),
                    Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _login,
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
                              'Sign In',
                              style: TextStyle(fontSize: fontMedium),
                            ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  Divider(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signInWithGoogle();
                              if (mounted &&
                                  ref.read(isAuthenticatedProvider)) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const MainScreen(),
                                  ),
                                );
                              }
                            },
                      icon: Image.network(
                        'https://dospace.org/wp-content/uploads/2018/01/Google_logo.jpg',
                        height: 22,
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: fontMedium),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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
