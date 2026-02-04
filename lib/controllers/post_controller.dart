import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;

  PostState({this.posts = const [], this.isLoading = false, this.error});

  PostState copyWith({List<PostModel>? posts, bool? isLoading, String? error}) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PostController extends StateNotifier<PostState> {
  PostController(this._service) : super(PostState()) {
    _listenPosts();
  }

  final PostService _service;
  StreamSubscription? _subscription;

  void _listenPosts() {
    state = state.copyWith(isLoading: true);

    _subscription = _service.getPosts().listen(
      (posts) {
        state = state.copyWith(posts: posts, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      },
    );
  }

  Future<void> createPost(PostModel post) async {
    await _service.createPost(post);
  }

  Future<void> toggleLike(PostModel post, String userId) async {
    await _service.toggleLike(post.id, userId, post.likes.contains(userId));
  }

  Future<void> deletePost(String postId) async {
    await _service.deletePost(postId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final postControllerProvider = StateNotifierProvider<PostController, PostState>(
  (ref) => PostController(PostService()),
);

final postsProvider = Provider<List<PostModel>>(
  (ref) => ref.watch(postControllerProvider).posts,
);
