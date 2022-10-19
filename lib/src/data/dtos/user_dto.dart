import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';

class UserDto {
  final String id;
  final String imageUrl;
  final String imagePath;
  final String name;
  final String email;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isCurrent;
  DocumentSnapshot? docSnapshot;

  UserDto({
    required this.id,
    required this.imageUrl,
    required this.imagePath,
    required this.name,
    required this.email,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isCurrent,
    required this.docSnapshot
  });

  factory UserDto.fromDoc(
    DocumentSnapshot userDoc,
    String currentUserId
  ) {
    Map userData = userDoc.data() as Map;
    return UserDto(
      id: userDoc.id,
      imageUrl: userData['imageUrl'] ?? '',
      imagePath: userData['imagePath'] ?? '',
      name: userData['username'],
      email: userData['email'],
      followersCount: userData['followersCount'],
      followingCount: userData['followingCount'],
      postsCount: userData['postsCount'],
      isCurrent: (userDoc.id == currentUserId),
      docSnapshot: userDoc
    );
  }

  UserDto.fromModel(User user) :
    id = user.id,
    imageUrl = user.imageUrl,
    imagePath = user.imagePath,
    name = user.name,
    email = user.email,
    followersCount = user.followersCount,
    followingCount = user.followingCount,
    postsCount = user.postsCount,
    isCurrent = user.isCurrent,
    docSnapshot = user.doc as DocumentSnapshot?;

  User toModel() => User(
    id: id,
    imageUrl: imageUrl,
    imagePath: imagePath,
    name: name,
    email: email,
    followersCount: followersCount,
    followingCount: followingCount,
    postsCount: postsCount,
    isCurrent: isCurrent,
    doc: docSnapshot
  );
}