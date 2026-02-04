import '../services/comment_service.dart';
import '../services/mock_data_service.dart';
import '../services/post_service.dart';

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
