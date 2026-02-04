import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_feed_app/utils/responsive_utils.dart';
import '../../../constants/app_colors.dart';
import 'create_post_postbar.dart';

// ================= Image Preview Section =================
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
    final height = images.length == 1
        ? ResponsiveUtils.responsiveValue<double>(
            context,
            mobile: 300,
            tablet: 400,
            desktop: 500,
          )
        : ResponsiveUtils.responsiveValue<double>(
            context,
            mobile: 200,
            tablet: 250,
            desktop: 300,
          );

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.responsiveValue<double>(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      ),
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
    final borderRadius = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
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
    final width = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 150,
      tablet: 200,
      desktop: 250,
    );
    final borderRadius = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
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

// Image Count Badge
class ImageCountBadge extends StatelessWidget {
  final int count;

  const ImageCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.fontSize(context, 12);
    final paddingH = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 10,
      tablet: 14,
      desktop: 18,
    );
    final paddingV = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 5,
      tablet: 8,
      desktop: 10,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$count ${count > 1 ? 'images' : 'image'}',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ================= Image Source Bottom Sheet =================
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
    final padding = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );
    final indicatorWidth = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 40,
      tablet: 60,
      desktop: 80,
    );
    final indicatorHeight = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 4,
      tablet: 5,
      desktop: 6,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: indicatorWidth,
              height: indicatorHeight,
              margin: EdgeInsets.only(bottom: padding),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(indicatorHeight / 2),
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
