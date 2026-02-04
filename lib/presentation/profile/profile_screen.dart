import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/post_controller.dart';
import '../auth/screens/login_screen.dart';
import 'widgets/profile_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final posts = ref
        .watch(postsProvider)
        .where((p) => p.userId == user?.id)
        .toList();

    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: ProfileAppBar(userName: user.name),
      body: ProfileBody(user: user, posts: posts),
    );
  }
}

// Profile AppBar Widget
class ProfileAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String userName;

  const ProfileAppBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(userName),
      backgroundColor: Colors.white,
      actions: [
        const SettingsIconButton(),
        LogoutIconButton(ref: ref),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Settings Icon Button Widget
class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings coming soon!')));
      },
    );
  }
}

// Logout Icon Button Widget
class LogoutIconButton extends StatelessWidget {
  final WidgetRef ref;

  const LogoutIconButton({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await ref.read(authControllerProvider.notifier).signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
    );
  }
}
