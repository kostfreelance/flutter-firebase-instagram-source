import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_user_repository.dart';

class UsersController extends GetxController with StateMixin<List<User>> {
  final IUserRepository _userRepository;
  final TextEditingController searchBarController = TextEditingController(); 
  final users = Rxn<List<User>>();

  bool get showInfinityLoader => users.value != null &&
    users.value!.isNotEmpty &&
    users.value!.last.doc != null;

  UsersController(this._userRepository) {
    fetchUsers();
  }

  @override
  void onClose() {
    searchBarController.dispose();
    super.onClose();
  }

  void fetchUsers() async {
    users.value = await _userRepository.getUsers(
      query: searchBarController.text
    );
  }

  void fetchNextUsers() async {
    if (searchBarController.text.isEmpty && showInfinityLoader) {
      users.value = users.value! + (await _userRepository.getUsers(
        doc: users.value![users.value!.length - 1].doc!
      ));
    }
  }

  void onSearchTermChanged() async {
    fetchUsers();
  }
}