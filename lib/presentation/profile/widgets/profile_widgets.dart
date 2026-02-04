// Profile Body Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/post_controller.dart';
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

// Profile Header Widget
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ProfileAvatar(user: user),
          const SizedBox(height: 16),
          ProfileUserInfo(user: user),
          if (user.bio != null) ProfileBio(bio: user.bio!),
          const SizedBox(height: 20),
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

// Profile Avatar Widget
class ProfileAvatar extends StatelessWidget {
  final dynamic user;

  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: user.photoUrl != null
          ? NetworkImage(user.photoUrl!)
          : null,
      backgroundColor: AppColors.border,
      child: user.photoUrl == null ? const Icon(Icons.person, size: 50) : null,
    );
  }
}

// Profile User Info Widget
class ProfileUserInfo extends StatelessWidget {
  final dynamic user;

  const ProfileUserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.username,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// Profile Bio Widget
class ProfileBio extends StatelessWidget {
  final String bio;

  const ProfileBio({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

// Profile Stats Widget
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

// Profile Stat Column Widget
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// Profile Posts List Widget
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

// Profile Empty Posts Widget
class ProfileEmptyPosts extends StatelessWidget {
  const ProfileEmptyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.post_add, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
