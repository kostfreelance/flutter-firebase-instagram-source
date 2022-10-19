import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/services/user_service.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final UserService _userService;
  UserRepository(this._userService);

  @override
  Future<List<User>> getUsers({
    String? query,
    Object? doc
  }) async {
    return (await _userService.getUsers(
      query,
      doc as DocumentSnapshot?
    )).map((userDto) =>
      userDto.toModel()
    ).toList();
  }

  @override
  Stream<User> watchUser(String userId) {
    return _userService.watchUser(userId)
      .asyncMap((userDto) => 
        userDto.toModel()
      );
  }

  @override
  Future<User> getCurrentUser() async {
    return (await _userService.getCurrentUser()).toModel();
  }
}