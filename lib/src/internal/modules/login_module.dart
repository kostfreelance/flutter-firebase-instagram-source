import 'package:flutter_firebase_instagram/src/domain/controllers/login_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/login_controller.dart';

abstract class LoginModule {
  static LoginController controller() {
    return LoginController();
  }
}