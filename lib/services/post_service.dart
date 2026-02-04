import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final _firestore = FirebaseFirestore.instance;

  // 🔹 Stream posts (real-time feed)
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((d) => PostModel.fromJson(d.data())).toList(),
        );
  }

  // 🔹 Create post
  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toJson());
  }

  // 🔹 Like / Unlike
  Future<void> toggleLike(String postId, String userId, bool liked) async {
    final ref = _firestore.collection('posts').doc(postId);

    await ref.update({
      'likes': liked
          ? FieldValue.arrayRemove([userId])
          : FieldValue.arrayUnion([userId]),
    });
  }

  // 🔹 Delete post
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
