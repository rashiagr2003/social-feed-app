/// User model representing a user in the app
class UserModel {
  final String id;
  final String email;
  final String name;
  final String username;
  final String? bio;
  final String? photoUrl;
  final String? coverPhotoUrl;
  final List<String> followers;
  final List<String> following;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.bio,
    this.photoUrl,
    this.coverPhotoUrl,
    List<String>? followers,
    List<String>? following,
    DateTime? createdAt,
    this.updatedAt,
  }) : followers = followers ?? [],
       following = following ?? [],
       createdAt = createdAt ?? DateTime.now();

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String?,
      coverPhotoUrl: json['coverPhotoUrl'] as String?,
      followers: (json['followers'] as List<dynamic>?)?.cast<String>() ?? [],
      following: (json['following'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'followers': followers,
      'following': following,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? bio,
    String? photoUrl,
    String? coverPhotoUrl,
    List<String>? followers,
    List<String>? following,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get follower count
  int get followerCount => followers.length;

  /// Get following count
  int get followingCount => following.length;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
