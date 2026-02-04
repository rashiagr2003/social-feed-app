// Image Preview Section Widget
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'create_post_postbar.dart';

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
