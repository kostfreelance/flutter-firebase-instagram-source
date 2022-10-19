import 'user_model.dart';

class Post {
  final String id;
  final User user;
  final String date;
  final String fileType;
  final String fileUrl;
  final String filePath;
  int likesCount;
  bool isLiked;
  final String caption;
  final int commentsCount;
  final Object? doc;

  Post({
    required this.id,
    required this.user,
    required this.date,
    required this.fileType,
    required this.fileUrl,
    required this.filePath,
    required this.likesCount,
    required this.isLiked,
    required this.caption,
    required this.commentsCount,
    required this.doc
  });
}