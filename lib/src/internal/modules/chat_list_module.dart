import 'package:flutter_firebase_instagram/src/domain/controllers/chat_list_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/chat_list_controller.dart';
import 'repository_module.dart';

abstract class ChatListModule {
  static ChatListController controller() {
    return ChatListController(
      RepositoryModule.chatRepository()
    );
  }
}