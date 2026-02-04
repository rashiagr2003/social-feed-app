import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive_utils.dart';

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
    // Responsive values
    final avatarRadius = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 20,
      tablet: 28,
      desktop: 32,
    );

    final iconSize = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 20,
      tablet: 28,
      desktop: 32,
    );

    final horizontalSpacing = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );

    final verticalSpacing = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 8,
      tablet: 12,
      desktop: 14,
    );

    final fontSizeName = ResponsiveUtils.fontSize(context, 14);
    final fontSizeInput = ResponsiveUtils.fontSize(context, 16);

    final paddingAll = ResponsiveUtils.responsivePadding(context);

    return Padding(
      padding: paddingAll,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            backgroundColor: AppColors.border,
            child: user?.photoUrl == null || user.photoUrl!.isEmpty
                ? Icon(
                    Icons.person,
                    size: iconSize,
                    color: Colors.grey.shade600,
                  )
                : null,
          ),
          SizedBox(width: horizontalSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeName,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 3,
                  autofocus: true,
                  style: TextStyle(fontSize: fontSizeInput),
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

class DiscardPostDialog extends StatelessWidget {
  final VoidCallback onDiscard;

  const DiscardPostDialog({super.key, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.fontSize(context, 16);

    return AlertDialog(
      title: Text('Discard post?', style: TextStyle(fontSize: fontSize + 2)),
      content: Text(
        'Are you sure you want to discard this post?',
        style: TextStyle(fontSize: fontSize),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(fontSize: fontSize)),
        ),
        TextButton(
          onPressed: onDiscard,
          child: Text(
            'Discard',
            style: TextStyle(fontSize: fontSize, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
