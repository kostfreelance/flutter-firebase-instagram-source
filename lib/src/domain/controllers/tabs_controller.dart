import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/action_sheet.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/post_add_screen.dart';

class TabsController extends GetxController {
  final PageController pageController = PageController();
  final pageIndex = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onTabPressed(
    int tabIndex,
    int postAddScreenIndex
  ) {
    if (tabIndex == postAddScreenIndex) {
      ActionSheet.open([
        ActionSheetItem(
          text: 'Take Photo',
          onPressed: () => _pickImage(ImageSource.camera)
        ), 
        ActionSheetItem(
          text: 'Photo from Library',
          onPressed: () => _pickImage(ImageSource.gallery)
        ), 
        ActionSheetItem(
          text: 'Take Video (10 secs)',
          onPressed: () => _pickVideo(ImageSource.camera)
        ), 
        ActionSheetItem(
          text: 'Video from Library (10 secs)',
          onPressed: () => _pickVideo(ImageSource.gallery)
        )
      ]);
    } else {
      pageController.jumpToPage(tabIndex);
      pageIndex.value = tabIndex;
    }
  }

  void _pickImage(ImageSource imageSource) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 400
    );
    if (pickedImage != null) {
      Get.to(PostAddScreen(
        file: AppFile(
          content: File(pickedImage.path),
          type: 'image'
        )
      ));
    }
  }

  void _pickVideo(ImageSource videoSource) async {
    XFile? pickedVideo = await ImagePicker().pickVideo(
      source: videoSource,
      maxDuration: const Duration(seconds: 10)
    );
    if (pickedVideo != null) {
      Get.to(PostAddScreen(
        file: AppFile(
          content: File(pickedVideo.path),
          type: 'video'
        )
      ));
    }
  }
}