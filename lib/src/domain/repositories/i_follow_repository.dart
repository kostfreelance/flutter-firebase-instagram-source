import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';

abstract class IFollowRepository {
  Future<List<User>> getFollowers(
    String userId,
    [Object? doc]
  );
  Future<List<User>> getFollowing(
    String userId,
    [Object? doc]
  );
  Future<void> follow(String userId);
  Future<void> unfollow(String userId);
  Future<bool> isFollowing(String userId);
}