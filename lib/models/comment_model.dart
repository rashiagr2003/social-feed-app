import 'package:cloud_firestore/cloud_firestore.dart';

/// Comment model representing a comment on a post
class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userPhotoUrl;
  final String content;
  final List<String> likes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userPhotoUrl,
    required this.content,
    List<String>? likes,
    DateTime? createdAt,
    this.updatedAt,
  }) : likes = likes ?? [],
       createdAt = createdAt ?? DateTime.now();

  // CommentModel
  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['id'],
    postId: json['postId'],
    userId: json['userId'],
    username: json['username'],
    userPhotoUrl: json['userPhotoUrl'],
    content: json['content'],
    likes: List<String>.from(json['likes'] ?? []),
    createdAt: (json['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'username': username,
    'userPhotoUrl': userPhotoUrl,
    'content': content,
    'likes': likes,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? userPhotoUrl,
    String? content,
    List<String>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get like count
  int get likeCount => likes.length;

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, userId: $userId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
