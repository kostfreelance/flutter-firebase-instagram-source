import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_firebase_instagram/src/domain/models/message_model.dart';
import 'user_dto.dart';

class MessageDto {
  final String id;
  final UserDto user;
  final String content;
  final DateTime date;
  DocumentSnapshot? docSnapshot;

  MessageDto({
    required this.id,
    required this.user,
    required this.content,
    required this.date,
    required this.docSnapshot
  });

  factory MessageDto.fromDoc(
    DocumentSnapshot messageDoc,
    UserDto user
  ) {
    Map messageData = messageDoc.data() as Map;
    return MessageDto(
      id: messageDoc.id,
      user: user,
      content: messageData['content'],
      date: messageData['date'].toDate(),
      docSnapshot: messageDoc
    );
  }

  Message toModel() => Message(
    id: id,
    user: user.toModel(),
    content: content,
    date: timeago.format(date),
    doc: docSnapshot
  );
}