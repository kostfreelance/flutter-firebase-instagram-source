import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_auth_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/login_screen.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/tabs_screen.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/loader.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/snackbar.dart';

class AuthController extends GetxController {
  final IAuthRepository _authRepository;
  AuthController(this._authRepository);
  
  Future<String> getInitialRoute() async {
    return _authRepository.isLoggedIn() ?
      TabsScreen.routeName :
      LoginScreen.routeName;
  }

  void login(
    String email,
    String password
  ) async {
    Loader.open();
    try {
      await _authRepository.login(email, password);
      Loader.close();
      Get.offNamed(TabsScreen.routeName);
    } catch (e) {
      Loader.close();
      Snackbar.open(
        e.toString(),
        color: AppColors.red
      );
    }
  }

  void register(
    String username,
    String email,
    String password
  ) async {
    Loader.open();
    try {
      await _authRepository.register(
        username, email, password
      );
      Loader.close();
      Get.offNamed(TabsScreen.routeName);
    } catch (e) {
      Loader.close();
      Snackbar.open(
        e.toString(),
        color: AppColors.red
      );
    }
  }

  Future<void> resetPassword(String email) async {
    Loader.open();
    try {
      await _authRepository.resetPassword(email);
      Loader.close();
      Snackbar.open('An email has been sent. Please click the link when you get it.');
    } catch (e) {
      Loader.close();
      Snackbar.open(
        e.toString(),
        color: AppColors.red
      );
    }
  }

  void updateProfile(
    String username,
    String password,
    String imagePath,
    File? imageFile
  ) async {
    Loader.open();
    try {
      await _authRepository.updateProfile(
        username, password, imagePath, imageFile
      );
      Loader.close();
      Get.back();
    } catch (e) {
      Loader.close();
      Snackbar.open(
        e.toString(),
        color: AppColors.red
      );
    }
  }

  void logout() async {
    await _authRepository.logout();
    Get.offNamed(LoginScreen.routeName);
  }
}