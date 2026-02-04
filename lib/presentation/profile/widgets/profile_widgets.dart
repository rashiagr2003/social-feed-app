// Profile Body Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/post_controller.dart';
import '../../../utils/responsive_utils.dart';
import '../../posts/screens/comment_screen.dart';
import '../../posts/widgets/post_card.dart';

class ProfileBody extends StatelessWidget {
  final dynamic user;
  final List posts;

  const ProfileBody({super.key, required this.user, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(user: user, postsCount: posts.length),
          const Divider(height: 1),
          ProfilePostsList(user: user, posts: posts),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final int postsCount;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.postsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: ResponsiveUtils.responsivePadding(context), // responsive padding
      child: Column(
        children: [
          ProfileAvatar(user: user),
          SizedBox(
            height: ResponsiveUtils.fontSize(context, 16),
          ), // responsive spacing
          ProfileUserInfo(user: user),
          if (user.bio != null) ProfileBio(bio: user.bio!),
          SizedBox(height: ResponsiveUtils.fontSize(context, 20)),
          ProfileStats(
            postsCount: postsCount,
            followersCount: user.followerCount,
            followingCount: user.followingCount,
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final dynamic user;

  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final double radius = ResponsiveUtils.responsiveValue(
      context,
      mobile: 50,
      tablet: 60,
      desktop: 70,
    );

    return CircleAvatar(
      radius: radius,
      backgroundImage: user.photoUrl != null
          ? NetworkImage(user.photoUrl!)
          : null,
      backgroundColor: AppColors.border,
      child: user.photoUrl == null ? Icon(Icons.person, size: radius) : null,
    );
  }
}

class ProfileUserInfo extends StatelessWidget {
  final dynamic user;

  const ProfileUserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.name,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.fontSize(context, 4)),
        Text(
          user.username,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 16),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class ProfileBio extends StatelessWidget {
  final String bio;

  const ProfileBio({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ResponsiveUtils.fontSize(context, 12)),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: ResponsiveUtils.fontSize(context, 14)),
        ),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatColumn(label: 'Posts', value: postsCount.toString()),
        ProfileStatColumn(label: 'Followers', value: followersCount.toString()),
        ProfileStatColumn(label: 'Following', value: followingCount.toString()),
      ],
    );
  }
}

class ProfileStatColumn extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStatColumn({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.fontSize(context, 4)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class ProfilePostsList extends ConsumerWidget {
  final dynamic user;
  final List posts;

  const ProfilePostsList({super.key, required this.user, required this.posts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (posts.isEmpty) {
      return const ProfileEmptyPosts();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          post: post,
          currentUserId: user.id,
          onLike: () {
            ref.read(postControllerProvider.notifier).toggleLike(post, user.id);
          },
          onComment: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CommentsScreen(post: post)),
            );
          },
          onShare: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Share coming soon!')));
          },
        );
      },
    );
  }
}

class ProfileEmptyPosts extends StatelessWidget {
  const ProfileEmptyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.responsivePadding(context), // responsive padding
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.post_add,
              size: ResponsiveUtils.responsiveValue(
                context,
                mobile: 60,
                tablet: 80,
                desktop: 100,
              ),
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: ResponsiveUtils.fontSize(context, 16),
            ), // responsive spacing
            Text(
              'No posts yet',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  16,
                ), // responsive font size
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
