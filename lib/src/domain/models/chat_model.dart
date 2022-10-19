import 'user_model.dart';
import 'message_model.dart';

class Chat {
  final String id;
  final User user;
  final Message? lastMessage;
  final bool hasUnreadMessages;

  Chat({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.hasUnreadMessages
  });
}