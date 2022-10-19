import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/controllers/profile_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/profile_controller.dart';
import 'repository_module.dart';

abstract class ProfileModule {
  static ProfileController controller(User? user) {
    return ProfileController(
      RepositoryModule.postRepository(),
      RepositoryModule.userRepository(),
      RepositoryModule.followRepository(),
      user
    );
  }
}