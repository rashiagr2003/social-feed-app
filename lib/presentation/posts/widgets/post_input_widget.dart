// Post Input Section Widget
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

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
