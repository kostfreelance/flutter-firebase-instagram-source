import 'package:flutter_firebase_instagram/src/domain/controllers/tabs_controller.dart';
export 'package:flutter_firebase_instagram/src/domain/controllers/tabs_controller.dart';

abstract class TabsModule {
  static TabsController controller() {
    return TabsController();
  }
}