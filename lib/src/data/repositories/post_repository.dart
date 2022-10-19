import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/post_dto.dart';
import 'package:flutter_firebase_instagram/src/data/services/post_service.dart';
import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_post_repository.dart';

class PostRepository implements IPostRepository {
  final PostService _postService;
  PostRepository(this._postService);

  @override
  Future<List<Post>> getPosts([Object? doc]) async {
    return (await _postService.getPosts(doc as DocumentSnapshot?)).map((postDto) =>
      postDto.toModel()
    ).toList();
  }

  @override
  Stream<List<Post>> watchPostsByUser(User user) {
    return _postService.watchPostsByUser(UserDto.fromModel(user))
      .asyncMap((postDtos) => 
        postDtos.map((postDto) =>
          postDto.toModel()
        ).toList()
      );
  }

  @override
  Future<List<Post>> getPostsByUser(
    User user,
    Object doc
  ) async {
    return (await _postService.getPostsByUser(
      UserDto.fromModel(user), (doc as DocumentSnapshot)
    )).map((postDto) =>
      postDto.toModel()
    ).toList();
  }

  @override
  Stream<Post> watchPost(String postId) {
    return _postService.watchPost(postId)
      .asyncMap((postDto) => 
        postDto.toModel()
      );
  }

  @override
  Future<void> addPost(
    String caption,
    AppFile file,
    { required Function(String) onStatusChanged }
  ) {
    return _postService.addPost(
      caption, file,
      onStatusChanged: onStatusChanged
    );
  }

  @override
  Future<void> removePost(Post post) {
    return _postService.removePost(PostDto.fromModel(post));
  }

  @override
  Future<void> likePost(String postId) {
    return _postService.likePost(postId);
  }

  @override
  Future<void> dislikePost(String postId) {
    return _postService.dislikePost(postId);
  }
}