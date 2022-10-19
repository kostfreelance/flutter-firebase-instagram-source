import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_follow_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/profile_screen.dart';

class FollowingController extends GetxController {
  final IFollowRepository _followRepository;
  final String _userId;
  final followingCount = 0.obs;
  final users = Rxn<List<User>>();

  bool get showInfinityLoader => users.value != null &&
    users.value!.isNotEmpty &&
    users.value!.last.doc != null;

  FollowingController(
    this._followRepository,
    this._userId
  ) {
    _fetchFollowing();
  }

  void _fetchFollowing() async {
    users.value = await _followRepository.getFollowing(_userId);
    followingCount.value = users.value!.length;
  }

  void fetchNextFollowing() async {
    if (showInfinityLoader) {
      users.value = users.value! + (await _followRepository.getFollowing(
        _userId, users.value![users.value!.length - 1].doc!
      ));
      followingCount.value = users.value!.length;
    }
  }

  void onUserPressed(User user) async {
    if (await Get.to(ProfileScreen(user: user))) {
      _fetchFollowing();
    }
  }
}