import 'package:flutter_firebase_instagram/src/domain/controllers/comments_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/comments_controller.dart';
import 'repository_module.dart';

abstract class CommentsModule {
  static CommentsController controller(String postId) {
    return CommentsController(
      RepositoryModule.commentRepository(),
      postId
    );
  }
}