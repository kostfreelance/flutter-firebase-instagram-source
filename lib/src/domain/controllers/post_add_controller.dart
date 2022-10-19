import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_post_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/status_loader.dart';
import 'home_controller.dart';

class PostAddController extends GetxController {
  final IPostRepository _postRepository;
  final AppFile _file;
  final TextEditingController captionController = TextEditingController();
  final isValid = false.obs;

  PostAddController(
    this._postRepository,
    this._file
  );

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }

  void onCaptionChanged() {
    isValid.value = captionController.text.isNotEmpty;
  }

  void onSharePressed() async {
    StatusLoader.open();
    try {
      await _postRepository.addPost(
        captionController.text,
        _file,
        onStatusChanged: (newStatus) =>
          StatusLoader.status = newStatus
      );
      StatusLoader.close();
      Get.back();
      Get.find<HomeController>().fetchPosts();
    } catch (_) {
      StatusLoader.close();
    }
  }
}