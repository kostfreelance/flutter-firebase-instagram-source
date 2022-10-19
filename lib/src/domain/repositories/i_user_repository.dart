import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';

abstract class IUserRepository {
  Future<List<User>> getUsers({
    String? query,
    Object? doc
  });
  Stream<User> watchUser(String userId);
  Future<User> getCurrentUser();
}