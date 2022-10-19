import 'package:flutter_firebase_instagram/src/domain/controllers/followers_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/followers_controller.dart';
import 'repository_module.dart';

abstract class FollowersModule {
  static FollowersController controller(String userId) {
    return FollowersController(
      RepositoryModule.followRepository(),
      userId
    );
  }
}