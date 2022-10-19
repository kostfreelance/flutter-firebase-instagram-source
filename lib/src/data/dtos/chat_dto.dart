import 'package:flutter_firebase_instagram/src/domain/models/chat_model.dart';
import 'user_dto.dart';
import 'message_dto.dart';

class ChatDto {
  final String id;
  final UserDto user;
  final MessageDto? lastMessage;
  final bool hasUnreadMessages;

  ChatDto({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.hasUnreadMessages
  });

  Chat toModel() => Chat(
    id: id,
    user: user.toModel(),
    lastMessage: lastMessage?.toModel(),
    hasUnreadMessages: hasUnreadMessages
  );
}