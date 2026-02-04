import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive_utils.dart';
import '../../posts/screens/feed_screen.dart';
import '../../posts/screens/post_screen.dart';
import '../../profile/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      FeedScreen(),
      ExploreScreen(),
      NotificationsScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fabSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
    final fabIconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );

    return Scaffold(
      appBar: null,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
              },
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add, color: Colors.white, size: fabIconSize),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 80.0,
      tablet: 100.0,
      desktop: 120.0,
    );
    final fontTitle = ResponsiveUtils.fontSize(context, 24);
    final fontSubtitle = ResponsiveUtils.fontSize(context, 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: iconSize, color: AppColors.textSecondary),
            SizedBox(height: ResponsiveUtils.screenHeight(context) * 0.02),
            Text(
              'Explore',
              style: TextStyle(
                fontSize: fontTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: fontSubtitle,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 80.0,
      tablet: 100.0,
      desktop: 120.0,
    );
    final fontTitle = ResponsiveUtils.fontSize(context, 24);
    final fontSubtitle = ResponsiveUtils.fontSize(context, 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              size: iconSize,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: ResponsiveUtils.screenHeight(context) * 0.02),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: fontTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: fontSubtitle,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
