import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive_utils.dart';

// ================= Custom Emoji Picker =================
class CustomEmojiPicker extends StatelessWidget {
  final Function(Category?, Emoji) onEmojiSelected;

  const CustomEmojiPicker({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    final height = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 250,
      tablet: 300,
      desktop: 350,
    );
    final emojiSize = ResponsiveUtils.responsiveValue<double>(
      context,
      mobile: 32,
      tablet: 36,
      desktop: 40,
    );

    return SizedBox(
      height: height,
      child: EmojiPicker(
        onEmojiSelected: onEmojiSelected,
        config: Config(
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: emojiSize,
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
