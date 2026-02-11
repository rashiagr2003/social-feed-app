import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive_utils.dart';

// ===================== CreatePostAppBar =====================
class CreatePostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isPosting;
  final bool hasContent;
  final VoidCallback onClose;
  final VoidCallback onPost;

  const CreatePostAppBar({
    super.key,
    required this.isPosting,
    required this.hasContent,
    required this.onClose,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    final spinnerSize = ResponsiveUtils.fontSize(context, 20);

    return AppBar(
      title: Text(
        'Create Post',
        style: TextStyle(fontSize: ResponsiveUtils.fontSize(context, 18)),
      ),
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
          size: ResponsiveUtils.fontSize(context, 24),
        ),
        onPressed: isPosting ? null : onClose,
      ),
      actions: [
        TextButton(
          onPressed: isPosting ? null : onPost,
          child: isPosting
              ? SizedBox(
                  width: spinnerSize,
                  height: spinnerSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Text(
                  'Post',
                  style: TextStyle(
                    color: hasContent ? AppColors.primary : Colors.grey,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        SizedBox(width: ResponsiveUtils.fontSize(context, 8)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ===================== PostInputSection =====================
class PostInputSection extends StatelessWidget {
  final dynamic user;
  final TextEditingController controller;
  final bool showEmojiPicker;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;

  const PostInputSection({
    super.key,
    required this.user,
    required this.controller,
    required this.showEmojiPicker,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.responsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: ResponsiveUtils.fontSize(context, 20),
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            backgroundColor: AppColors.border,
            child: user?.photoUrl == null || user.photoUrl!.isEmpty
                ? Icon(
                    Icons.person,
                    size: ResponsiveUtils.fontSize(context, 20),
                    color: Colors.grey.shade600,
                  )
                : null,
          ),
          SizedBox(width: ResponsiveUtils.fontSize(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.fontSize(context, 8)),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 3,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                  ),
                  onTap: onTap,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== ImagePreviewSection =====================
class ImagePreviewSection extends StatelessWidget {
  final List<File> images;
  final Function(int) onRemove;

  const ImagePreviewSection({
    super.key,
    required this.images,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: images.length == 1
          ? ResponsiveUtils.screenHeight(context) * 0.35
          : ResponsiveUtils.screenHeight(context) * 0.25,
      padding: ResponsiveUtils.horizontalPadding(context),
      child: images.length == 1
          ? SingleImagePreview(image: images[0], onRemove: () => onRemove(0))
          : MultipleImagesPreview(images: images, onRemove: onRemove),
    );
  }
}

// ===================== SingleImagePreview =====================
class SingleImagePreview extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;

  const SingleImagePreview({
    super.key,
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.fontSize(context, 12),
            ),
            border: Border.all(color: Colors.grey.shade300),
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: ResponsiveUtils.fontSize(context, 8),
          right: ResponsiveUtils.fontSize(context, 8),
          child: RemoveImageButton(onTap: onRemove),
        ),
      ],
    );
  }
}

// ===================== MultipleImagesPreview =====================
class MultipleImagesPreview extends StatelessWidget {
  final List<File> images;
  final Function(int) onRemove;

  const MultipleImagesPreview({
    super.key,
    required this.images,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: ResponsiveUtils.fontSize(context, 8),
              ),
              width: ResponsiveUtils.screenWidth(context) * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.fontSize(context, 12),
                ),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  image: FileImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: ResponsiveUtils.fontSize(context, 8),
              right: ResponsiveUtils.fontSize(context, 16),
              child: RemoveImageButton(
                onTap: () => onRemove(index),
                size: ResponsiveUtils.fontSize(context, 18),
                padding: ResponsiveUtils.fontSize(context, 4),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ===================== RemoveImageButton =====================
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

// ===================== ImageCountBadge =====================
class ImageCountBadge extends StatelessWidget {
  final int count;

  const ImageCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$count ${count > 1 ? 'images' : 'image'}',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ===================== CustomEmojiPicker =====================
class CustomEmojiPicker extends StatelessWidget {
  final Function(Category?, Emoji) onEmojiSelected;

  const CustomEmojiPicker({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: onEmojiSelected,
        config: Config(
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 32,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            backgroundColor: const Color(0xFFF2F2F2),
            buttonMode: ButtonMode.MATERIAL,
            loadingIndicator: const SizedBox.shrink(),
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
          ),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.RECENT,
            backgroundColor: const Color(0xFFF2F2F2),
            indicatorColor: AppColors.primary,
            iconColor: Colors.grey,
            iconColorSelected: AppColors.primary,
            backspaceColor: AppColors.primary,
            categoryIcons: const CategoryIcons(),
            tabIndicatorAnimDuration: kTabScrollDuration,
          ),
          skinToneConfig: const SkinToneConfig(
            enabled: true,
            dialogBackgroundColor: Colors.white,
            indicatorColor: Colors.grey,
          ),
          bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
        ),
      ),
    );
  }
}

// ===================== ImageSourceBottomSheet =====================
class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const ImageSourceBottomSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: onGalleryTap,
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: onCameraTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== DiscardPostDialog =====================
class DiscardPostDialog extends StatelessWidget {
  final VoidCallback onDiscard;

  const DiscardPostDialog({super.key, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Discard post?'),
      content: const Text('Are you sure you want to discard this post?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDiscard,
          child: const Text('Discard', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
