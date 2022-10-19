import 'package:flutter_firebase_instagram/src/domain/controllers/register_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/register_controller.dart';

abstract class RegisterModule {
  static RegisterController controller() {
    return RegisterController();
  }
}