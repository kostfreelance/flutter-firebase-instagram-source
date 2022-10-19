import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/comment_dto.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'firebase_service.dart';
import 'user_service.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final int _pageLimitCount = 15;

  Stream<List<CommentDto>> watchComments(String postId) {
    Query commentsQuery = _firestore
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .orderBy('date')
      .limit(_pageLimitCount + 1);
    return commentsQuery.snapshots().map<QuerySnapshot>((el) => el).transform(
      StreamTransformer<QuerySnapshot, List<CommentDto>>
        .fromHandlers(handleData: (commentsSnapshot, sink) async {
          sink.add(await _getCommentsByDocs(commentsSnapshot.docs));
        })
    );
  }

  Future<List<CommentDto>> getComments(
    String postId,
    DocumentSnapshot? docSnapshot,
    int? limitCount,
    bool? descOrder
  ) async {
    Query commentsQuery = _firestore
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .orderBy('date', descending: descOrder ?? false);
    if (docSnapshot != null) {
      commentsQuery = commentsQuery.startAfterDocument(docSnapshot);
    }
    commentsQuery = commentsQuery.limit(limitCount ?? (_pageLimitCount + 1));
    List<DocumentSnapshot> commentDocs = (await commentsQuery.get()).docs;
    return _getCommentsByDocs(commentDocs);
  }

  Future<void> addComment(
    String postId,
    String content
  ) async {
    DocumentReference postRef = _firestore
      .collection('posts')
      .doc(postId);
    await postRef
      .collection('comments')
      .add({
        'userId': FirebaseService.getCurrentUserId(),
        'content': content,
        'date': DateTime.now()
      });
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      tx.update(postRef, {
        'commentsCount': (postSnapshot.data() as Map)['commentsCount'] + 1
      });
      return;
    });
  }

  Future<List<CommentDto>> _getCommentsByDocs(
    List<DocumentSnapshot> commentDocs
  ) async {
    if (commentDocs.isEmpty) {
      return [];
    }
    bool isLastPage = commentDocs.length < (_pageLimitCount + 1);
    if (commentDocs.length > _pageLimitCount) {
      commentDocs = commentDocs.sublist(0, _pageLimitCount);
    }
    List<String> commentsUserIds = commentDocs.map((commentDoc) =>
      (commentDoc.data() as Map)['userId']
    ).cast<String>().toList();
    commentsUserIds = commentsUserIds.toSet().toList();
    List<UserDto> commentUsers = await _userService.getUsersByIds(commentsUserIds);
    List<CommentDto> comments = commentDocs.map((commentDoc) =>
      CommentDto.fromDoc(
        commentDoc,
        commentUsers.firstWhere((commentUser) =>
          commentUser.id == (commentDoc.data() as Map)['userId']
        )
      )
    ).toList();
    if (isLastPage) {
      comments.last.docSnapshot = null;
    }
    return comments;
  }
}