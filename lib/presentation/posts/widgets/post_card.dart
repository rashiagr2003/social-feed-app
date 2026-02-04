import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/post_model.dart';
import '../../../utils/responsive_utils.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post, formattedDate: _formatDate(post.createdAt)),
          if (post.content.isNotEmpty) PostContent(content: post.content),
          if (post.imageUrls.isNotEmpty)
            PostImageGallery(imageUrls: post.imageUrls),
          PostActions(
            post: post,
            isLiked: isLiked,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
          ),
        ],
      ),
    );
  }
}

// ================= Post Header =================
class PostHeader extends StatelessWidget {
  final PostModel post;
  final String formattedDate;

  const PostHeader({
    super.key,
    required this.post,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );

    return Padding(
      padding: EdgeInsets.all(spacing),
      child: Row(
        children: [
          UserAvatar(photoUrl: post.userPhotoUrl),
          SizedBox(width: spacing),
          Expanded(
            child: UserInfo(
              username: post.username,
              formattedDate: formattedDate,
            ),
          ),
          const PostOptionsButton(),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String photoUrl;

  const UserAvatar({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final radius = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 20,
      tablet: 28,
      desktop: 32,
    );

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.border,
      child: ClipOval(
        child: buildLocalOrNetworkImage(
          photoUrl,
          width: radius * 2,
          height: radius * 2,
        ),
      ),
    );
  }

  Widget buildLocalOrNetworkImage(
    String? imagePathOrUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imagePathOrUrl == null || imagePathOrUrl.isEmpty) {
      return Image.network(
        'https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148874050.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (imagePathOrUrl.startsWith('http')) {
      return Image.network(
        imagePathOrUrl,
        width: width,
        height: height,
        fit: fit,
      );
    }

    final file = File(imagePathOrUrl);
    if (!file.existsSync()) {
      return Image.network(
        'https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148874050.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.file(file, width: width, height: height, fit: fit);
  }
}

class UserInfo extends StatelessWidget {
  final String username;
  final String formattedDate;

  const UserInfo({
    super.key,
    required this.username,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final fontSizeUsername = ResponsiveUtils.fontSize(context, 15);
    final fontSizeDate = ResponsiveUtils.fontSize(context, 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSizeUsername,
          ),
        ),
        Text(
          formattedDate,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: fontSizeDate,
          ),
        ),
      ],
    );
  }
}

// ================= Post Content =================
class PostContent extends StatelessWidget {
  final String content;

  const PostContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final fontSize = ResponsiveUtils.fontSize(context, 15);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding / 1.5,
      ),
      child: Text(content, style: TextStyle(fontSize: fontSize, height: 1.4)),
    );
  }
}

// ================= Post Actions =================
class PostActions extends StatelessWidget {
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostActions({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 32,
      tablet: 40,
      desktop: 48,
    );

    return Padding(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveValue<double>(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
      ),
      child: Row(
        children: [
          PostActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? AppColors.like : AppColors.textSecondary,
            label: post.likeCount.toString(),
            onTap: onLike,
          ),
          SizedBox(width: spacing),
          PostActionButton(
            icon: Icons.chat_bubble_outline,
            color: AppColors.textSecondary,
            label: post.commentCount.toString(),
            onTap: onComment,
          ),
          SizedBox(width: spacing),
          PostActionButton(
            icon: Icons.share_outlined,
            color: AppColors.textSecondary,
            label: post.shareCount.toString(),
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}

class PostActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const PostActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 22,
      tablet: 28,
      desktop: 32,
    );
    final fontSize = ResponsiveUtils.fontSize(context, 14);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class PostOptionsButton extends StatelessWidget {
  const PostOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_horiz, color: AppColors.textSecondary),
      onPressed: () {},
    );
  }
}

class PostImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const PostImageGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              return PostImageItem(
                imageUrl: imageUrls[index],
                isFirst: index == 0,
                isLast: index == imageUrls.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

class PostImageItem extends StatelessWidget {
  final String imageUrl;
  final bool isFirst;
  final bool isLast;

  const PostImageItem({
    super.key,
    required this.imageUrl,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isFirst ? 12 : 4, right: isLast ? 12 : 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: buildLocalOrNetworkImage(
          imageUrl,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildLocalOrNetworkImage(
    String? imagePathOrUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imagePathOrUrl == null || imagePathOrUrl.isEmpty) {
      return Image.network(
        'https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148874050.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (imagePathOrUrl.startsWith('http')) {
      return Image.network(
        imagePathOrUrl,
        width: width,
        height: height,
        fit: fit,
      );
    }

    final file = File(imagePathOrUrl);
    if (!file.existsSync()) {
      return Image.network(
        'https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148874050.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.file(file, width: width, height: height, fit: fit);
  }
}
