import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'user_dto.dart';

class CommentDto {
  final String id;
  final UserDto user;
  final String content;
  final String date;
  DocumentSnapshot? docSnapshot;

  CommentDto({
    required this.id,
    required this.user,
    required this.content,
    required this.date,
    required this.docSnapshot
  });

  factory CommentDto.fromDoc(
    DocumentSnapshot commentDoc,
    UserDto user
  ) {
    Map messageData = commentDoc.data() as Map;
    return CommentDto(
      id: commentDoc.id,
      user: user,
      content: messageData['content'],
      date: timeago.format(messageData['date'].toDate()),
      docSnapshot: commentDoc
    );
  }

  Comment toModel() => Comment(
    id: id,
    user: user.toModel(),
    content: content,
    date: date,
    doc: docSnapshot
  );
}