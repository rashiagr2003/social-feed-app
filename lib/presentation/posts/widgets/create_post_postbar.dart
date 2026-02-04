import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';

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
    return AppBar(
      title: const Text('Create Post'),
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: isPosting ? null : onClose,
      ),
      actions: [
        TextButton(
          onPressed: isPosting ? null : onPost,
          child: isPosting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Post',
                  style: TextStyle(
                    color: hasContent ? AppColors.primary : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Post Input Section Widget
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
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            backgroundColor: AppColors.border,
            child: user?.photoUrl == null || user.photoUrl!.isEmpty
                ? Icon(Icons.person, size: 20, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 3,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16),
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

// Image Preview Section Widget
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
      height: images.length == 1 ? 300 : 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: images.length == 1
          ? SingleImagePreview(image: images[0], onRemove: () => onRemove(0))
          : MultipleImagesPreview(images: images, onRemove: onRemove),
    );
  }
}

// Single Image Preview Widget
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
        ),
        Positioned(top: 8, right: 8, child: RemoveImageButton(onTap: onRemove)),
      ],
    );
  }
}

// Multiple Images Preview Widget
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
              margin: const EdgeInsets.only(right: 8),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  image: FileImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: RemoveImageButton(
                onTap: () => onRemove(index),
                size: 18,
                padding: 4,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Remove Image Button Widget
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

// Image Count Badge Widget
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

// Custom Emoji Picker Widget
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

// Image Source Bottom Sheet Widget
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

// Discard Post Dialog Widget
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
