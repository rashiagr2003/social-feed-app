import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import 'comment_service.dart';
import 'post_service.dart';

/// Mock data service for testing UI before Firebase integration
class MockDataService {
  // Mock users
  static List<UserModel> getMockUsers() {
    return [
      UserModel(
        id: 'user1',
        email: 'john.doe@example.com',
        name: 'John Doe',
        username: '@johndoe',
        bio: 'Flutter Developer | Tech Enthusiast | Coffee Lover ☕',
        photoUrl: 'https://i.pravatar.cc/150?img=1',
        followers: ['user2', 'user3', 'user4'],
        following: ['user2', 'user5'],
      ),
      UserModel(
        id: 'user2',
        email: 'jane.smith@example.com',
        name: 'Jane Smith',
        username: '@janesmith',
        bio: 'Designer & Developer | UI/UX Enthusiast 🎨',
        photoUrl: 'https://i.pravatar.cc/150?img=5',
        followers: ['user1', 'user3'],
        following: ['user1', 'user4'],
      ),
      UserModel(
        id: 'user3',
        email: 'mike.wilson@example.com',
        name: 'Mike Wilson',
        username: '@mikewilson',
        bio: 'Full Stack Developer | Open Source Contributor',
        photoUrl: 'https://i.pravatar.cc/150?img=12',
        followers: ['user1', 'user2', 'user4', 'user5'],
        following: ['user1'],
      ),
      UserModel(
        id: 'user4',
        email: 'sarah.johnson@example.com',
        name: 'Sarah Johnson',
        username: '@sarahjohnson',
        bio: 'Product Manager | Tech Speaker 🎤',
        photoUrl: 'https://i.pravatar.cc/150?img=20',
        followers: ['user3', 'user5'],
        following: ['user1', 'user2', 'user3'],
      ),
      UserModel(
        id: 'user5',
        email: 'alex.brown@example.com',
        name: 'Alex Brown',
        username: '@alexbrown',
        bio: 'Mobile App Developer | Flutter Expert 📱',
        photoUrl: 'https://i.pravatar.cc/150?img=33',
        followers: ['user1', 'user4'],
        following: ['user2', 'user3'],
      ),
    ];
  }

  // Mock posts
  static List<PostModel> getMockPosts() {
    final users = getMockUsers();
    return [
      PostModel(
        id: 'post1',
        userId: users[0].id,
        username: users[0].name,
        userPhotoUrl: users[0].photoUrl ?? '',
        content:
            'Just launched my new Flutter app! 🚀 The journey was challenging but incredibly rewarding. Cant wait to share more updates with you all!',
        imageUrls: ['https://picsum.photos/800/600?random=1'],
        likes: ['user2', 'user3', 'user4'],
        commentCount: 5,
        shareCount: 2,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: 'post2',
        userId: users[1].id,
        username: users[1].name,
        userPhotoUrl: users[1].photoUrl ?? '',
        content:
            'New UI design for our mobile app. What do you think? Feedback is always welcome! 🎨✨',
        imageUrls: [
          'https://picsum.photos/800/600?random=2',
          'https://picsum.photos/800/600?random=3',
        ],
        likes: ['user1', 'user3', 'user5'],
        commentCount: 8,
        shareCount: 4,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostModel(
        id: 'post3',
        userId: users[2].id,
        username: users[2].name,
        userPhotoUrl: users[2].photoUrl ?? '',
        content:
            'Working on a new open source project. Contributors are welcome! Check out the repo on GitHub. #OpenSource #Developer',
        likes: ['user1', 'user2', 'user4', 'user5'],
        commentCount: 12,
        shareCount: 6,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      PostModel(
        id: 'post4',
        userId: users[3].id,
        username: users[3].name,
        userPhotoUrl: users[3].photoUrl ?? '',
        content:
            'Excited to announce that Ill be speaking at the upcoming Tech Conference! See you there! 🎤',
        imageUrls: ['https://picsum.photos/800/600?random=4'],
        likes: ['user1', 'user2'],
        commentCount: 3,
        shareCount: 1,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      PostModel(
        id: 'post5',
        userId: users[4].id,
        username: users[4].name,
        userPhotoUrl: users[4].photoUrl ?? '',
        content:
            'Flutter 3.0 is amazing! The performance improvements are incredible. Time to update all my apps! 📱💙',
        likes: ['user1', 'user3'],
        commentCount: 7,
        shareCount: 3,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      PostModel(
        id: 'post6',
        userId: users[0].id,
        username: users[0].name,
        userPhotoUrl: users[0].photoUrl ?? '',
        content:
            'Coffee and code - the perfect combination for a productive morning! ☕💻',
        imageUrls: ['https://picsum.photos/800/600?random=5'],
        likes: ['user2', 'user4', 'user5'],
        commentCount: 4,
        shareCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Mock comments
  static List<CommentModel> getMockComments(String postId) {
    final users = getMockUsers();
    return [
      CommentModel(
        id: 'comment1',
        postId: postId,
        userId: users[1].id,
        username: users[1].name,
        userPhotoUrl: users[1].photoUrl ?? '',
        content: 'This is awesome! Congratulations! 🎉',
        likes: ['user1', 'user3'],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CommentModel(
        id: 'comment2',
        postId: postId,
        userId: users[2].id,
        username: users[2].name,
        userPhotoUrl: users[2].photoUrl ?? '',
        content: 'Great work! Looking forward to trying it out.',
        likes: ['user1'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      CommentModel(
        id: 'comment3',
        postId: postId,
        userId: users[3].id,
        username: users[3].name,
        userPhotoUrl: users[3].photoUrl ?? '',
        content: 'Love the design! Very clean and modern.',
        likes: ['user1', 'user2', 'user4'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      CommentModel(
        id: 'comment4',
        postId: postId,
        userId: users[4].id,
        username: users[4].name,
        userPhotoUrl: users[4].photoUrl ?? '',
        content: 'Impressive work! Keep it up! 👏',
        likes: ['user1', 'user2'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];
  }

  // Get current user (mock)
  static UserModel getCurrentUser() {
    return getMockUsers()[0]; // Return first user as current user
  }
}

Future<void> uploadMockDataToFirestore() async {
  final postService = PostService();
  final commentService = CommentService();

  // Upload posts
  for (var post in MockDataService.getMockPosts()) {
    await postService.createPost(post);

    // Upload comments for each post
    final comments = MockDataService.getMockComments(post.id);
    for (var comment in comments) {
      await commentService.addComment(comment);
    }
  }

  print('✅ All mock posts and comments uploaded to Firestore!');
}
