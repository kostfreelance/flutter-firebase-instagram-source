import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'package:flutter_firebase_instagram/src/data/services/chat_service.dart';
import 'package:flutter_firebase_instagram/src/domain/models/chat_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/message_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_chat_repository.dart';

class ChatRepository implements IChatRepository {
  final ChatService _chatService;
  ChatRepository(this._chatService);

  @override
  Stream<List<Chat>> watchChats() {
    return _chatService.watchChats()
      .asyncMap((chatDtos) => 
        chatDtos.map((chatDto) =>
          chatDto.toModel()
        ).toList()
      );
  }

  @override
  Future<String?> getChatIdByUserId(String userId) {
    return _chatService.getChatIdByUserId(userId);
  }

  @override
  Future<String> createChat(String userId) {
    return _chatService.createChat(userId);
  }

  @override
  Future<void> removeChat(String chatId) {
    return _chatService.removeChat(chatId);
  }

  @override
  Stream<List<Message>> watchMessages(
    String chatId,
    User user
  ) {
    return _chatService.watchMessages(chatId, UserDto.fromModel(user))
      .asyncMap((messageDtos) => 
        messageDtos.map((messageDto) =>
          messageDto.toModel()
        ).toList()
      );
  }

  @override
  Future<List<Message>> getMessages(
    String chatId,
    User user,
    Object doc
  ) async {
    return (await _chatService.getMessages(
      chatId, UserDto.fromModel(user), (doc as DocumentSnapshot)
    )).map((messageDto) =>
      messageDto.toModel()
    ).toList();
  }

  @override
  Future<void> createMessage(
    String chatId,
    String content
  ) {
    return _chatService.createMessage(chatId, content);
  }

  @override
  Future<void> updateMemberLastVisitDate(String chatId) {
    return _chatService.updateMemberLastVisitDate(chatId);
  }
}