import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_post_repository.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_user_repository.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_follow_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/confirm_alert.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final IPostRepository _postRepository;
  final IUserRepository _userRepository;
  final IFollowRepository _followRepository;
  final User? _user;
  StreamSubscription? _getPostsSubscription;
  StreamSubscription? _getUserSubscription;
  bool followingChanged = false;
  final posts = Rxn<List<Post>>();
  final user = Rxn<User>();
  final isFollowing = false.obs;

  bool get showInfinityLoader => posts.value != null &&
    posts.value!.isNotEmpty &&
    posts.value!.last.doc != null;

  ProfileController(
    this._postRepository,
    this._userRepository,
    this._followRepository,
    this._user
  ) {
    _init();
  }

  @override
  void onClose() {
    _getPostsSubscription?.cancel();
    _getUserSubscription?.cancel();
    super.onClose();
  }

  void _init() async {
    if (_user != null) {
      isFollowing.value = await _followRepository.isFollowing(_user!.id);
    }
    user.value = _user ?? await _userRepository.getCurrentUser();
    _getPostsSubscription = _postRepository
      .watchPostsByUser(user.value!)
      .listen((newPosts) {
        posts.value = newPosts;
      });
    _getUserSubscription = _userRepository
      .watchUser(user.value!.id)
      .listen((newUser) {
        user.value = newUser;
      });
  }

  void fetchNextPosts() async {
    if (showInfinityLoader) {
      posts.value = posts.value! + (await _postRepository.getPostsByUser(
        user.value!,
        posts.value![posts.value!.length - 1].doc!
      ));
    }
  }

  void onFollowPressed() async {
    followingChanged = true;
    isFollowing.value = !isFollowing.value;
    if (isFollowing.value) {
      await _followRepository.follow(user.value!.id);
    } else {
      await _followRepository.unfollow(user.value!.id);
    }
  }

  void onLogoutPressed() {
    ConfirmAlert.open(
      'Are you sure you want to logout?',
      onConfirm: Get.find<AuthController>().logout
    );
  }

  void onBackPressed() {
    Get.back(result: followingChanged);
  }
}