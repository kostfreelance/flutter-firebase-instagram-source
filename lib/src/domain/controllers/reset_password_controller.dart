import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final isValid = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void validate() {
    isValid.value = GetUtils.isEmail(emailController.text);
  }
}