import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_post_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/loader.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/confirm_alert.dart';

class HomeController extends GetxController {
  final IPostRepository _postRepository; 
  final posts = Rxn<List<Post>>();

  bool get showInfinityLoader => posts.value != null &&
    posts.value!.isNotEmpty &&
    posts.value!.last.doc != null;

  HomeController(this._postRepository) {
    fetchPosts();
  }

  void fetchPosts() async {
    posts.value = await _postRepository.getPosts();
  }

  void fetchNextPosts() async {
    if (showInfinityLoader) {
      posts.value = posts.value! + (await _postRepository.getPosts(
        posts.value![posts.value!.length - 1].doc!
      ));
    }
  }

  void onLikePressed(int postIndex) async {
    Post post = posts.value![postIndex];
    if (post.isLiked) {
      post.isLiked = false;
      post.likesCount--;
      posts.refresh();
      await _postRepository.dislikePost(post.id);
    } else {
      post.isLiked = true;
      post.likesCount++;
      posts.refresh();
      await _postRepository.likePost(post.id);
    }
  }

  void onSharePressed(Post post) {
    Share.share(
      'yourApp ${post.fileUrl}',
      sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1)
    );
  }

  void onRemovePressed(Post oldPost) {
    ConfirmAlert.open(
      'Are you sure you want to delete this post?',
      onConfirm: () async {
        Loader.open();
        try {
          await _postRepository.removePost(oldPost);
          fetchPosts();
        } finally {
          Loader.close();
        }
      }
    );
  }
}