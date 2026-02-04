import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
import '../../../models/post_model.dart';
import '../../../controllers/post_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/storage_service.dart';
import '../widgets/create_post_postbar.dart';
import '../../../utils/responsive_utils.dart';
import '../widgets/remove_image_button.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _isPosting = false;
  bool _showEmojiPicker = false;
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(imageQuality: 80);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking images: $e')));
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveUtils.responsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
        ),
      ),
      builder: (context) => ImageSourceBottomSheet(
        onGalleryTap: () {
          Navigator.pop(context);
          _pickImage();
        },
        onCameraTap: () {
          Navigator.pop(context);
          _pickImageFromCamera();
        },
      ),
    );
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _toggleEmojiPicker() {
    setState(() => _showEmojiPicker = !_showEmojiPicker);
    if (_showEmojiPicker) FocusScope.of(context).unfocus();
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && selection.start >= 0) {
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        emoji.emoji,
      );
      final newCursor = selection.start + emoji.emoji.length;
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursor),
      );
    } else {
      _contentController.text += emoji.emoji;
      _contentController.selection = TextSelection.collapsed(
        offset: _contentController.text.length,
      );
    }
  }

  Future<void> _createPost() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    if (_contentController.text.trim().isEmpty && _selectedImages.isEmpty)
      return;

    setState(() => _isPosting = true);

    try {
      List<String> imagePaths = [];
      if (_selectedImages.isNotEmpty) {
        final storage = LocalStorageService();
        for (var image in _selectedImages) {
          final path = await storage.saveImage(image);
          imagePaths.add(path!);
        }
      }

      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        username: user.name,
        userPhotoUrl: user.photoUrl ?? '',
        content: _contentController.text.trim(),
        imageUrls: imagePaths,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        createdAt: DateTime.now(),
      );

      await ref.read(postControllerProvider.notifier).createPost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  void _handleClose() {
    if (_contentController.text.isNotEmpty || _selectedImages.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => DiscardPostDialog(
          onDiscard: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final spacingSmall = ResponsiveUtils.responsiveValue(
      context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );
    final spacingMedium = ResponsiveUtils.responsiveValue(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    return Scaffold(
      appBar: CreatePostAppBar(
        isPosting: _isPosting,
        hasContent:
            _contentController.text.isNotEmpty || _selectedImages.isNotEmpty,
        onClose: _handleClose,
        onPost: _createPost,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: spacingMedium.toDouble(),
              ),
              child: Column(
                children: [
                  PostInputSection(
                    user: user,
                    controller: _contentController,
                    showEmojiPicker: _showEmojiPicker,
                    onTap: () {
                      if (_showEmojiPicker)
                        setState(() => _showEmojiPicker = false);
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_selectedImages.isNotEmpty) ...[
                    SizedBox(height: spacingSmall.toDouble()),
                    ImagePreviewSection(
                      images: _selectedImages,
                      onRemove: _removeImage,
                    ),
                    SizedBox(height: spacingMedium.toDouble()),
                  ],
                ],
              ),
            ),
          ),
          Divider(height: 1),
          PostActionsBar(
            isPosting: _isPosting,
            selectedImagesCount: _selectedImages.length,
            showEmojiPicker: _showEmojiPicker,
            onImageTap: _showImageSourceDialog,
            onEmojiTap: _toggleEmojiPicker,
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: ResponsiveUtils.responsiveValue(
                context,
                mobile: 250,
                tablet: 300,
                desktop: 350,
              ),
              child: CustomEmojiPicker(onEmojiSelected: _onEmojiSelected),
            ),
        ],
      ),
    );
  }
}
