import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'firebase_service.dart';
import 'user_service.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final int _pageLimitCount = 15;

  Future<List<UserDto>> getFollowers(
    String userId,
    DocumentSnapshot? docSnapshot
  ) {
    return _getFollowUsers(userId, docSnapshot, 'followers');
  }

  Future<List<UserDto>> getFollowing(
    String userId, 
    DocumentSnapshot? docSnapshot
  ) {
    return _getFollowUsers(userId, docSnapshot, 'following');
  }

  Future<List<UserDto>> _getFollowUsers(
    String userId, 
    DocumentSnapshot? docSnapshot,
    String collectionPath
  ) async {
    Query query = _firestore
      .collection('users')
      .doc(userId)
      .collection(collectionPath)
      .orderBy('date', descending: true);
    if (docSnapshot != null) {
      query = query.startAfterDocument(docSnapshot);
    }
    query = query.limit(_pageLimitCount + 1);
    QuerySnapshot followSnapshot = await query.get();
    List<String> followIds = followSnapshot.docs.map((followingDoc) => followingDoc.id).toList();
    if (followIds.isEmpty) {
      return [];
    }
    bool isLastPage = followIds.length < (_pageLimitCount + 1);
    if (followIds.length > _pageLimitCount) {
      followIds = followIds.sublist(0, _pageLimitCount);
    }
    List<UserDto> users = (await _userService.getUsersByIds(followIds)).asMap().map((userIndex, user) { 
      user.docSnapshot = followSnapshot.docs[userIndex];
      return MapEntry(
        userIndex, user
      );
    }).values.toList();
    if (isLastPage) {
      users.last.docSnapshot = null;
    }
    return users;
  }

  Future<void> follow(String userId) async {
    String currentUserId = FirebaseService.getCurrentUserId();
    DocumentReference followingRef = _firestore
        .collection('users')
        .doc(userId);
    DocumentReference followerRef = _firestore
        .collection('users')
        .doc(currentUserId);
    await followingRef
      .collection('followers')
      .doc(currentUserId)
      .set({
        'date': DateTime.now()
      });
    await followerRef
      .collection('following')
      .doc(userId)
      .set({
        'date': DateTime.now()
      });
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot followingSnapshot = await tx.get(followingRef);
      DocumentSnapshot followerSnapshot = await tx.get(followerRef);
      tx.update(followingRef, {
        'followersCount': (followingSnapshot.data() as Map)['followersCount'] + 1
      });
      tx.update(followerRef, {
        'followingCount': (followerSnapshot.data() as Map)['followingCount'] + 1
      });
      return;
    });
  }

  Future<void> unfollow(String userId) async {
    String currentUserId = FirebaseService.getCurrentUserId();
    DocumentReference followingRef = _firestore
        .collection('users')
        .doc(userId);
    DocumentReference followerRef = _firestore
        .collection('users')
        .doc(currentUserId);
    await followingRef
      .collection('followers')
      .doc(currentUserId)
      .delete();
    await followerRef
      .collection('following')
      .doc(userId)
      .delete();
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot followingSnapshot = await tx.get(followingRef);
      DocumentSnapshot followerSnapshot = await tx.get(followerRef);
      tx.update(followingRef, {
        'followersCount': (followingSnapshot.data() as Map)['followersCount'] - 1
      });
      tx.update(followerRef, {
        'followingCount': (followerSnapshot.data() as Map)['followingCount'] - 1
      });
    });
  }

  Future<bool> isFollowing(String userId) async {
    DocumentSnapshot followingSnapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('followers')
      .doc(FirebaseService.getCurrentUserId())
      .get();
    return followingSnapshot.exists;
  }
}