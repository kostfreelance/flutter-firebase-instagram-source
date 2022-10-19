import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';

abstract class ICommentRepository {
  Stream<List<Comment>> watchComments(String postId);
  Future<List<Comment>> getComments(
    String postId, {
      Object? doc,
      int? limitCount,
      bool? descOrder
    }
  );
  Future<void> addComment(
    String postId,
    String content
  );
}