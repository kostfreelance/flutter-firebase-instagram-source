import 'package:flutter_firebase_instagram/src/domain/controllers/auth_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/auth_controller.dart';
import 'repository_module.dart';

abstract class AuthModule {
  static AuthController controller() {
    return AuthController(
      RepositoryModule.authRepository()
    );
  }
}