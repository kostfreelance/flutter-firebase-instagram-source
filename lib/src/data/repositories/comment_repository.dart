import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/services/comment_service.dart';
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_comment_repository.dart';

class CommentRepository implements ICommentRepository {
  final CommentService _commentService;
  CommentRepository(this._commentService);

  @override
  Stream<List<Comment>> watchComments(String postId) {
    return _commentService.watchComments(postId)
      .asyncMap((commentDtos) => 
        commentDtos.map((commentDto) =>
          commentDto.toModel()
        ).toList()
      );
  }

  @override
  Future<List<Comment>> getComments(
    String postId, {
      Object? doc,
      int? limitCount,
      bool? descOrder
    }
  ) async {
    return (await _commentService.getComments(
      postId,
      doc as DocumentSnapshot?,
      limitCount,
      descOrder
    )).map((commentDto) =>
      commentDto.toModel()
    ).toList();
  }

  @override
  Future<void> addComment(String postId, String content) {
    return _commentService.addComment(postId, content);
  }
}