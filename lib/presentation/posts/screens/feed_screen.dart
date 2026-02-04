import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/post_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/responsive_utils.dart';
import '../widgets/post_card.dart';
import 'comment_screen.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postControllerProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: const FeedAppBar(),
      body: FeedBody(postState: postState, currentUser: currentUser),
    );
  }
}

// Feed AppBar Widget
class FeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Social Feed',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      actions: const [SearchIconButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Search Icon Button Widget
class SearchIconButton extends StatelessWidget {
  const SearchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        // TODO: Implement search
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Search coming soon!')));
      },
    );
  }
}

// Feed Body Widget
class FeedBody extends ConsumerWidget {
  final PostState postState;
  final dynamic currentUser;

  const FeedBody({
    super.key,
    required this.postState,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    if (postState.isLoading && postState.posts.isEmpty) {
      return const FeedLoadingIndicator();
    }

    if (postState.posts.isEmpty) {
      return const FeedEmptyView();
    }

    return FeedPostList(posts: postState.posts, currentUser: currentUser);
  }
}

// Feed Loading Indicator Widget
class FeedLoadingIndicator extends StatelessWidget {
  const FeedLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}

class FeedEmptyView extends StatelessWidget {
  const FeedEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 60.0,
      tablet: 80.0,
      desktop: 100.0,
    );
    final fontTitle = ResponsiveUtils.fontSize(context, 18);
    final fontSubtitle = ResponsiveUtils.fontSize(context, 14);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.post_add, size: iconSize, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: fontTitle,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to create a post!',
            style: TextStyle(fontSize: fontSubtitle, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class FeedPostList extends ConsumerWidget {
  final List posts;
  final dynamic currentUser;

  const FeedPostList({
    super.key,
    required this.posts,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final post = posts[index];
        return FeedPostItem(post: post, currentUser: currentUser);
      },
    );
  }
}

// Feed Post Item Widget
class FeedPostItem extends ConsumerWidget {
  final dynamic post;
  final dynamic currentUser;

  const FeedPostItem({
    super.key,
    required this.post,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PostCard(
      post: post,
      currentUserId: currentUser?.id ?? '',
      onLike: () {
        if (currentUser != null) {
          ref
              .read(postControllerProvider.notifier)
              .toggleLike(post, currentUser.id);
        }
      },
      onComment: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => CommentsScreen(post: post)));
      },
      onShare: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Share coming soon!')));
      },
    );
  }
}
