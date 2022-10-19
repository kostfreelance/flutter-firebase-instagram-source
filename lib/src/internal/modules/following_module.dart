import 'package:flutter_firebase_instagram/src/domain/controllers/following_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/following_controller.dart';
import 'repository_module.dart';

abstract class FollowingModule {
  static FollowingController controller(String userId) {
    return FollowingController(
      RepositoryModule.followRepository(),
      userId
    );
  }
}