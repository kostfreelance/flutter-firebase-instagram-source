import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/controllers/chat_detail_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/chat_detail_controller.dart';
import 'repository_module.dart';

abstract class ChatDetailModule {
  static ChatDetailController controller(
    User user,
    String? chatId
  ) {
    return ChatDetailController(
      RepositoryModule.chatRepository(),
      user,
      chatId
    );
  }
}