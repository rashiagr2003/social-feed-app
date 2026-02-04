import 'package:cloud_firestore/cloud_firestore.dart';

/// Post model representing a social media post
class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userPhotoUrl;
  final String content;
  final List<String> imageUrls;
  final List<String> likes;
  final int commentCount;
  final int shareCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userPhotoUrl,
    required this.content,
    List<String>? imageUrls,
    List<String>? likes,
    this.commentCount = 0,
    this.shareCount = 0,
    DateTime? createdAt,
    this.updatedAt,
  }) : imageUrls = imageUrls ?? [],
       likes = likes ?? [],
       createdAt = createdAt ?? DateTime.now();

  // PostModel
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'],
    userId: json['userId'],
    username: json['username'],
    userPhotoUrl: json['userPhotoUrl'],
    content: json['content'],
    imageUrls: List<String>.from(json['imageUrls'] ?? []),
    likes: List<String>.from(json['likes'] ?? []),
    commentCount: json['commentCount'] ?? 0,
    shareCount: json['shareCount'] ?? 0,
    createdAt: (json['createdAt'] as Timestamp).toDate(), // Firestore Timestamp
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'username': username,
    'userPhotoUrl': userPhotoUrl,
    'content': content,
    'imageUrls': imageUrls,
    'likes': likes,
    'commentCount': commentCount,
    'shareCount': shareCount,
    'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
  };

  /// Create a copy of PostModel with updated fields
  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userPhotoUrl,
    String? content,
    List<String>? imageUrls,
    List<String>? likes,
    int? commentCount,
    int? shareCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get like count
  int get likeCount => likes.length;

  /// Check if post has images
  bool get hasImages => imageUrls.isNotEmpty;

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
