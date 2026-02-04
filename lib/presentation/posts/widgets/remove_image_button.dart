import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive_utils.dart';
import 'create_post_postbar.dart';

// Remove Image Button Widget
class RemoveImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? size;
  final double? padding;

  const RemoveImageButton({
    super.key,
    required this.onTap,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize =
        size ??
        ResponsiveUtils.responsiveValue<double>(
          context,
          mobile: 20,
          tablet: 28,
          desktop: 32,
        );

    final iconPadding =
        padding ??
        ResponsiveUtils.responsiveValue<double>(
          context,
          mobile: 6,
          tablet: 10,
          desktop: 12,
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(iconPadding),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close, color: Colors.white, size: iconSize),
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
    final iconSize = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 28,
      tablet: 36,
      desktop: 40,
    );

    final spacing = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing / 2,
        vertical: spacing / 4,
      ),
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
              size: iconSize,
            ),
            tooltip: 'Add Image',
          ),
          if (selectedImagesCount > 0)
            Padding(
              padding: EdgeInsets.only(left: spacing / 2),
              child: ImageCountBadge(count: selectedImagesCount),
            ),
          SizedBox(width: spacing),
          IconButton(
            onPressed: isPosting ? null : onEmojiTap,
            icon: Icon(
              showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
              color: isPosting ? Colors.grey : AppColors.primary,
              size: iconSize,
            ),
            tooltip: 'Add Emoji',
          ),
        ],
      ),
    );
  }
}
