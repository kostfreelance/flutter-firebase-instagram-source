import 'package:flutter_firebase_instagram/src/domain/controllers/reset_password_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/reset_password_controller.dart';

abstract class ResetPasswordModule {
  static ResetPasswordController controller() {
    return ResetPasswordController();
  }
}