import 'dart:io';

abstract class IAuthRepository {
  bool isLoggedIn();
  Future<void> login(
    String email,
    String password
  );
  Future<void> logout();
  Future<void> register(
    String username,
    String email,
    String password
  );
  Future<void> resetPassword(String email);
  Future<void> updateProfile(
    String userName,
    String password,
    String imagePath,
    File? imageFile
  );
}