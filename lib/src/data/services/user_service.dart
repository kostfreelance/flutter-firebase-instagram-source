import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'firebase_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageLimitCount = 15;

  Future<List<UserDto>> getUsers(
    String? query,
    DocumentSnapshot? docSnapshot
  ) async {
    Query usersQuery = _firestore
      .collection('users')
      .orderBy('date', descending: true);
    bool withQuery = query != null && query.isNotEmpty;
    if (withQuery) {
      usersQuery = usersQuery.where('searchTerms', arrayContains: query.toLowerCase());
    }
    if (docSnapshot != null) {
      usersQuery = usersQuery.startAfterDocument(docSnapshot);
    }
    if (!withQuery) {
      usersQuery = usersQuery.limit(_pageLimitCount + 1);
    }
    List<DocumentSnapshot> userDocs = (await usersQuery.get()).docs;
    if (userDocs.isEmpty) {
      return [];
    }
    bool isLastPage = true;
    if (!withQuery) {
      isLastPage = userDocs.length < (_pageLimitCount + 1);
      if (userDocs.length > _pageLimitCount) {
        userDocs = userDocs.sublist(0, _pageLimitCount);
      }
    }
    String currentUserId = FirebaseService.getCurrentUserId();
    List<UserDto> users = (await _getUsersByDocs(userDocs)).where((user) =>
      user.id != currentUserId
    ).toList();
    if (isLastPage && users.isNotEmpty) {
      users.last.docSnapshot = null;
    }
    return users;
  }

  Stream<UserDto> watchUser(String userId) {
    DocumentReference userRef = _firestore
      .collection('users')
      .doc(userId);
    return userRef.snapshots().map<DocumentSnapshot>((el) => el).transform(
      StreamTransformer<DocumentSnapshot, UserDto>
        .fromHandlers(handleData: (userDoc, sink) {
          sink.add(UserDto.fromDoc(
            userDoc,
            FirebaseService.getCurrentUserId()
          ));
        })
    );
  }

  Future<UserDto> getCurrentUser() async {
    return getUser(FirebaseService.getCurrentUserId());
  }

  Future<List<UserDto>> getUsersByIds(
    List<String> userIds
  ) async {
    List<DocumentSnapshot> userDocs = await FirebaseService.getDocsByIds(
      userIds, 'users', FieldPath.documentId
    );
    List<DocumentSnapshot> sortedUserDocs = [];
    for (String userId in userIds) {
      DocumentSnapshot foundUserDoc = userDocs.firstWhere((userDoc) =>
        userDoc.id == userId
      );
      sortedUserDocs.add(foundUserDoc);
    }
    return _getUsersByDocs(sortedUserDocs);
  }

  Future<UserDto> getUser(String userId) async {
    DocumentSnapshot userSnapshot = await _firestore
      .collection('users')
      .doc(userId)
      .get();
    return UserDto.fromDoc(userSnapshot, FirebaseService.getCurrentUserId());
  }

  Future<List<UserDto>> _getUsersByDocs(
    List<DocumentSnapshot> userDocs
  ) async {
    String currentUserId = FirebaseService.getCurrentUserId();
    return userDocs.map((userDoc) =>
      UserDto.fromDoc(
        userDoc,
        currentUserId
      )
    ).toList();
  }
}