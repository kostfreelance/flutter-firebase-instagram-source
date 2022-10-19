import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/controllers/post_detail_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/post_detail_controller.dart';
import 'repository_module.dart';

abstract class PostDetailModule {
  static PostDetailController controller(Post post) {
    return PostDetailController(
      RepositoryModule.postRepository(),
      RepositoryModule.commentRepository(),
      post
    );
  }
}