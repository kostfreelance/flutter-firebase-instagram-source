import 'package:get/get.dart';
import 'app_progress_indicator.dart';

abstract class Loader {
  static void open() {
    Get.dialog(
      const AppProgressIndicator(),
      barrierDismissible: false
    );
  }

  static void close() {
    Get.back();
  }
}