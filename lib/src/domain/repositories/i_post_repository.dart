import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts([Object? doc]);
  Stream<List<Post>> watchPostsByUser(User user);
  Future<List<Post>> getPostsByUser(
    User user,
    Object doc
  );
  Stream<Post> watchPost(String postId);
  Future<void> addPost(
    String caption,
    AppFile file,
    { required Function(String) onStatusChanged }
  );
  Future<void> removePost(Post post);
  Future<void> likePost(String postId);
  Future<void> dislikePost(String postId);
}