import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_follow_repository.dart';

class FollowersController extends GetxController {
  final IFollowRepository _followRepository;
  final String _userId;
  final followersCount = 0.obs;
  final users = Rxn<List<User>>();

  bool get showInfinityLoader => users.value != null &&
    users.value!.isNotEmpty &&
    users.value!.last.doc != null;

  FollowersController(
    this._followRepository,
    this._userId
  ) {
    _fetchFollowers();
  }

  void _fetchFollowers() async {
    users.value = await _followRepository.getFollowers(_userId);
    followersCount.value = users.value!.length;
  }

  void fetchNextFollowers() async {
    if (showInfinityLoader) {
      users.value = users.value! + (await _followRepository.getFollowers(
        _userId, users.value![users.value!.length - 1].doc!
      ));
      followersCount.value = users.value!.length;
    }
  }
}