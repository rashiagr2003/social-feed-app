// Remove Image Button Widget
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'create_post_postbar.dart';

class RemoveImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final double padding;

  const RemoveImageButton({
    super.key,
    required this.onTap,
    this.size = 20,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close, color: Colors.white, size: size),
      ),
    );
  }
}

// Post Actions Bar Widget
class PostActionsBar extends StatelessWidget {
  final bool isPosting;
  final int selectedImagesCount;
  final bool showEmojiPicker;
  final VoidCallback onImageTap;
  final VoidCallback onEmojiTap;

  const PostActionsBar({
    super.key,
    required this.isPosting,
    required this.selectedImagesCount,
    required this.showEmojiPicker,
    required this.onImageTap,
    required this.onEmojiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: isPosting ? null : onImageTap,
            icon: Icon(
              Icons.image_outlined,
              color: isPosting ? Colors.grey : AppColors.primary,
              size: 28,
            ),
            tooltip: 'Add Image',
          ),
          if (selectedImagesCount > 0)
            ImageCountBadge(count: selectedImagesCount),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isPosting ? null : onEmojiTap,
            icon: Icon(
              showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
              color: isPosting ? Colors.grey : AppColors.primary,
              size: 28,
            ),
            tooltip: 'Add Emoji',
          ),
        ],
      ),
    );
  }
}
