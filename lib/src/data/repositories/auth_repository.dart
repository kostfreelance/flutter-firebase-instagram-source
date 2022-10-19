import 'dart:io';
import 'package:flutter_firebase_instagram/src/data/services/auth_service.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final AuthService _dayService;
  AuthRepository(this._dayService);

  @override
  bool isLoggedIn() {
    return _dayService.isLoggedIn();
  }

  @override
  Future<void> login(
    String email,
    String password
  ) {
    return _dayService.login(email, password);
  }

  @override
  Future<void> logout() {
    return _dayService.logout();
  }

  @override
  Future<void> register(
    String username,
    String email,
    String password
  ) {
    return _dayService.register(username, email, password);
  }

  @override
  Future<void> resetPassword(String email) {
    return _dayService.resetPassword(email);
  }

  @override
  Future<void> updateProfile(
    String userName,
    String password,
    String imagePath,
    File? imageFile
  ) {
    return _dayService.updateProfile(
      userName,
      password,
      imagePath,
      imageFile
    );
  }
}