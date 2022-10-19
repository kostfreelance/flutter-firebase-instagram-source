import 'package:flutter_firebase_instagram/src/domain/models/chat_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/message_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';

abstract class IChatRepository {
  Stream<List<Chat>> watchChats();
  Future<String?> getChatIdByUserId(String userId);
  Future<String> createChat(String userId);
  Future<void> removeChat(String chatId);
  Stream<List<Message>> watchMessages(
    String chatId,
    User user
  );
  Future<List<Message>> getMessages(
    String chatId,
    User user,
    Object doc
  );
  Future<void> createMessage(
    String chatId,
    String content
  );
  Future<void> updateMemberLastVisitDate(String chatId);
}