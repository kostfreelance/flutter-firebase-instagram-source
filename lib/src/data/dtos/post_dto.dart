import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'user_dto.dart';

class PostDto {
  final String id;
  final UserDto user;
  final String date;
  final String fileType;
  final String fileUrl;
  final String filePath;
  final int likesCount;
  final bool isLiked;
  final String caption;
  final int commentsCount;
  DocumentSnapshot? docSnapshot;

  PostDto({
    required this.id,
    required this.user,
    required this.date,
    required this.fileType,
    required this.fileUrl,
    required this.filePath,
    required this.likesCount,
    required this.isLiked,
    required this.caption,
    required this.commentsCount,
    required this.docSnapshot
  });

  factory PostDto.fromDoc(
    DocumentSnapshot postDoc,
    UserDto user,
    bool isLiked
  ) {
    Map postData = postDoc.data() as Map;
    return PostDto(
      id: postDoc.id,
      user: user,
      date: timeago.format(postDoc['date'].toDate()),
      fileType: postData['fileType'],
      fileUrl: postData['fileUrl'],
      filePath: postData['filePath'],
      likesCount: postData['likesCount'],
      isLiked: isLiked,
      caption: postData['caption'],
      commentsCount: postData['commentsCount'],
      docSnapshot: postDoc
    );
  }

  PostDto.fromModel(Post post) : 
    id = post.id,
    user = UserDto.fromModel(post.user),
    date = post.date,
    fileType = post.fileType,
    fileUrl = post.fileUrl,
    filePath = post.filePath,
    likesCount = post.likesCount,
    isLiked = post.isLiked,
    caption = post.caption,
    commentsCount = post.commentsCount,
    docSnapshot = post.doc as DocumentSnapshot?;

  Post toModel() => Post(
    id: id,
    user: user.toModel(),
    date: date,
    fileType: fileType,
    fileUrl: fileUrl,
    filePath: filePath,
    likesCount: likesCount,
    isLiked: isLiked,
    caption: caption,
    commentsCount: commentsCount,
    doc: docSnapshot
  );
}