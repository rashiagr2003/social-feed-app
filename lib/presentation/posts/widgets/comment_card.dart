import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../models/comment_model.dart';
import '../../../utils/responsive_utils.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final String currentUserId;

  const CommentCard({
    super.key,
    required this.comment,
    required this.currentUserId,
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
    final double avatarRadius = ResponsiveUtils.fontSize(context, 18);
    final double spacing = ResponsiveUtils.fontSize(context, 12);
    final double usernameFont = ResponsiveUtils.fontSize(context, 14);
    final double contentFont = ResponsiveUtils.fontSize(context, 14);
    final double dateFont = ResponsiveUtils.fontSize(context, 12);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.fontSize(context, 12)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: comment.userPhotoUrl.isNotEmpty
                ? NetworkImage(comment.userPhotoUrl)
                : null,
            backgroundColor: AppColors.border,
            child: comment.userPhotoUrl.isEmpty
                ? Icon(Icons.person, size: avatarRadius)
                : null,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: usernameFont,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.fontSize(context, 8)),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: dateFont,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.fontSize(context, 4)),
                Text(
                  comment.content,
                  style: TextStyle(fontSize: contentFont, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
