import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/domain/controllers/post_add_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/post_add_controller.dart';
import 'repository_module.dart';

abstract class PostAddModule {
  static PostAddController controller(AppFile file) {
    return PostAddController(
      RepositoryModule.postRepository(),
      file
    );
  }
}