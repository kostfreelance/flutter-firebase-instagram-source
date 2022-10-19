import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/services/follow_service.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_follow_repository.dart';

class FollowRepository implements IFollowRepository {
  final FollowService _followService;
  FollowRepository(this._followService);

  @override
  Future<List<User>> getFollowers(
    String userId,
    [Object? doc]
  ) async {
    return (await _followService.getFollowers(
      userId,
      doc as DocumentSnapshot?
    )).map((followerDto) =>
      followerDto.toModel()
    ).toList();
  }

  @override
  Future<List<User>> getFollowing(
    String userId,
    [Object? doc]
  ) async {
    return (await _followService.getFollowing(
      userId,
      doc as DocumentSnapshot?
    )).map((followingDto) =>
      followingDto.toModel()
    ).toList();
  }

  @override
  Future<void> follow(String userId) {
    return _followService.follow(userId);
  }

  @override
  Future<void> unfollow(String userId) {
    return _followService.unfollow(userId);
  }

  @override
  Future<bool> isFollowing(String userId) {
    return _followService.isFollowing(userId);
  }
}