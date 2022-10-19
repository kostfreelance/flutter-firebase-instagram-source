import 'package:flutter_firebase_instagram/src/domain/controllers/home_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/home_controller.dart';
import 'repository_module.dart';

abstract class HomeModule {
  static HomeController controller() {
    return HomeController(
      RepositoryModule.postRepository()
    );
  }
}