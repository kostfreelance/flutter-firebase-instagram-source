import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/controllers/profile_edit_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/profile_edit_controller.dart';

abstract class ProfileEditModule {
  static ProfileEditController controller(User user) {
    return ProfileEditController(user);
  }
}