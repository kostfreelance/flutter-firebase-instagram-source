import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_comment_repository.dart';

class CommentsController extends GetxController {
  final ICommentRepository _commentRepository;
  final String _postId;
  final TextEditingController commentController = TextEditingController();
  StreamSubscription? _getCommentsSubscription;
  final isCommentValid = false.obs;
  final comments = Rxn<List<Comment>>();

  bool get showInfinityLoader => comments.value != null &&
    comments.value!.isNotEmpty &&
    comments.value!.last.doc != null;

  CommentsController(
    this._commentRepository,
    this._postId
  ) {
    _init();
  }

  @override
  void onClose() {
    commentController.dispose();
    _getCommentsSubscription?.cancel();
    super.onClose();
  }

  void _init() {
    _getCommentsSubscription = _commentRepository
      .watchComments(_postId)
      .listen((newComments) {
        comments.value = newComments;
      });
  }

  void fetchNextComments() async {
    if (showInfinityLoader) {
      comments.value = comments.value! + (await _commentRepository.getComments(
        _postId, doc: comments.value![comments.value!.length - 1].doc!
      ));
    }
  }

  void onCommentChanged() {
    isCommentValid.value = commentController.text.isNotEmpty;
  }

  void onPostPressed() async {
    String comment = commentController.text;
    commentController.text = '';
    onCommentChanged();
    await _commentRepository.addComment(_postId, comment);
  }
}