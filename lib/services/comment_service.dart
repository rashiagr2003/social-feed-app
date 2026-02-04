import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => CommentModel.fromJson(d.data())).toList(),
        );
  }

  Future<void> addComment(CommentModel comment) async {
    final ref = _firestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.id);

    await ref.set(comment.toJson());

    await _firestore.collection('posts').doc(comment.postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }
}
