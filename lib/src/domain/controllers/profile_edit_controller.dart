import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/action_sheet.dart';

class ProfileEditController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final imageFile = Rxn<File>();
  final isValid = true.obs;

  ProfileEditController(User user) {
    emailController.text = user.email;
    usernameController.text = user.name;
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void validate() {
    isValid.value = usernameController.text.isNotEmpty &&
      (passwordController.text == confirmPasswordController.text);
  }

  void onImagePressed() {
    ActionSheet.open([
      ActionSheetItem(
        text: 'Take Photo',
        onPressed: () => _pickImage(ImageSource.camera)
      ), 
      ActionSheetItem(
        text: 'Photo from Library',
        onPressed: () => _pickImage(ImageSource.gallery)
      )
    ]);
  }

  void _pickImage(ImageSource imageSource) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 100
    );
    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    }
  }
}