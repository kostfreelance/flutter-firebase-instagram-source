import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_post_repository.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_comment_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/loader.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/confirm_alert.dart';
import 'home_controller.dart';

class PostDetailController extends GetxController {
  final IPostRepository _postRepository;
  final ICommentRepository _commentRepository;
  final Post _post;
  final HomeController _homeController = Get.find();
  StreamSubscription? _getPostSubscription;
  final isLiked = false.obs;
  final likesCount = 0.obs;
  final commentsCount = 0.obs;
  final comments = Rxn<List<Comment>>();

  PostDetailController(
    this._postRepository,
    this._commentRepository,
    this._post
  ) {
    _init();
  }

  @override
  void onClose() {
    _getPostSubscription?.cancel();
    super.onClose();
  }

  void _init() async {
    _initValues(_post);
    _getPostSubscription = _postRepository
      .watchPost(_post.id)
      .listen((newPost) =>
        _initValues(newPost)
      );
    comments.value = await _commentRepository.getComments(
      _post.id,
      limitCount: 2,
      descOrder: true
    );
  }

  void _initValues(Post newPost) async {
    isLiked.value = newPost.isLiked;
    likesCount.value = newPost.likesCount;
    commentsCount.value = newPost.commentsCount;
  }

  void onLikePressed() async {
    if (isLiked.value) {
      isLiked.value = false;
      likesCount.value--;
      await _postRepository.dislikePost(_post.id);
    } else {
      isLiked.value = true;
      likesCount.value++;
      await _postRepository.likePost(_post.id);
    }
    _homeController.fetchPosts();
  }

  void onSharePressed() {
    Share.share(
      'yourApp ${_post.fileUrl}',
      sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1)
    );
  }

  void onRemovePressed() {
    ConfirmAlert.open(
      'Are you sure you want to delete this post?',
      onConfirm: () async {
        Get.back();
        Loader.open();
        try {
          await _postRepository.removePost(_post);
          Loader.close();
          _homeController.fetchPosts();
        } catch (_) {
          Loader.close();
        }
      }
    );
  }
}