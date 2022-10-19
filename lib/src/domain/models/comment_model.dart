import 'user_model.dart';

class Comment {
  final String id;
  final User user;
  final String content;
  final String date;
  final Object? doc;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.date,
    required this.doc
  });
}