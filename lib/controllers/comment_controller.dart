import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

class CommentState {
  final List<CommentModel> comments;
  final bool isLoading;
  final String? error;

  CommentState({this.comments = const [], this.isLoading = false, this.error});

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CommentController extends StateNotifier<CommentState> {
  CommentController(this._service) : super(CommentState());

  final CommentService _service;
  StreamSubscription? _sub;

  void listenComments(String postId) {
    state = state.copyWith(isLoading: true);

    _sub?.cancel();
    _sub = _service.getComments(postId).listen((comments) {
      state = state.copyWith(comments: comments, isLoading: false);
    });
  }

  Future<void> addComment(CommentModel comment) async {
    await _service.addComment(comment);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final commentControllerProvider =
    StateNotifierProvider<CommentController, CommentState>(
      (ref) => CommentController(CommentService()),
    );
