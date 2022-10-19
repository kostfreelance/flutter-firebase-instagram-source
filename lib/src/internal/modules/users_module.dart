import 'package:flutter_firebase_instagram/src/domain/controllers/users_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/users_controller.dart';
import 'repository_module.dart';

abstract class UsersModule {
  static UsersController controller() {
    return UsersController(
      RepositoryModule.userRepository()
    );
  }
}