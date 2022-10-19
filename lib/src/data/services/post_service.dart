import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/post_dto.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'firebase_service.dart';
import 'storage_service.dart';
import 'user_service.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final int _gridLimitCount = 15;
  final int _pageLimitCount = 5;

  Future<List<PostDto>> getPosts(DocumentSnapshot? docSnapshot) async {
    List<String> userIds = [FirebaseService.getCurrentUserId()];
    QuerySnapshot followingSnapshot = await _firestore
      .collection('users')
      .doc(userIds[0])
      .collection('following')
      .get();
    userIds += followingSnapshot.docs.map((followingDoc) =>
      followingDoc.id
    ).toList();
    List<DocumentSnapshot> postDocs = await FirebaseService.getDocsByIds(
      userIds,
      'posts',
      'userId',
      docSnapshot: docSnapshot,
      limit: _pageLimitCount + 1,
      orderByField: 'date',
      orderByDescending: true
    );
    return _getPostsByDocs(postDocs, _pageLimitCount);
  }

  Stream<List<PostDto>> watchPostsByUser(UserDto user) {
    Query postsQuery = _firestore
      .collection('posts')
      .where('userId', isEqualTo: user.id)
      .orderBy('date', descending: true)
      .limit(_gridLimitCount + 1);
    return postsQuery.snapshots().map<QuerySnapshot>((el) => el).transform(
      StreamTransformer<QuerySnapshot, List<PostDto>>
        .fromHandlers(handleData: (postsSnapshot, sink) async {
          sink.add(await _getPostsByDocs(postsSnapshot.docs, _gridLimitCount, user));
        })
    );
  }

  Future<List<PostDto>> getPostsByUser(
    UserDto user,
    DocumentSnapshot docSnapshot
  ) async {
    Query postsQuery = _firestore
      .collection('posts')
      .where('userId', isEqualTo: user.id)
      .orderBy('date', descending: true)
      .startAfterDocument(docSnapshot)
      .limit(_gridLimitCount + 1);
    List<DocumentSnapshot> postDocs = (await postsQuery.get()).docs;
    return _getPostsByDocs(postDocs, _gridLimitCount, user);
  }

  Stream<PostDto> watchPost(String postId) {
    DocumentReference postRef = _firestore
      .collection('posts')
      .doc(postId);
    return postRef.snapshots().map<DocumentSnapshot>((el) => el).transform(
      StreamTransformer<DocumentSnapshot, PostDto>
        .fromHandlers(handleData: (postDoc, sink) async {
          sink.add(await _getPostByDoc(postDoc));
        })
    );
  }

  Future<void> addPost(
    String caption,
    AppFile file,
    { required Function(String) onStatusChanged }
  ) async {
    String currentUserId = FirebaseService.getCurrentUserId();
    StorageFile newPostFile = await StorageService.saveFile(
      file.content,
      'posts/$currentUserId${DateTime.now().millisecondsSinceEpoch.toString()}${p.extension(file.content.path)}',
      onStatusChanged: onStatusChanged
    );
    await _firestore
      .collection('posts')
      .add({
        'caption': caption,
        'fileUrl': newPostFile.url,
        'fileType': file.type,
        'filePath': newPostFile.path,
        'date': DateTime.now(),
        'userId': currentUserId,
        'likesCount': 0,
        'commentsCount': 0
      });
    await _firestore.runTransaction((Transaction tx) async {
      DocumentReference userRef = _firestore
        .collection('users')
        .doc(currentUserId);
      DocumentSnapshot userSnapshot = await tx.get(userRef);
      tx.update(userRef, {
        'postsCount': (userSnapshot.data() as Map)['postsCount'] + 1
      });
      return;
    });
    onStatusChanged('100%');
    return;
  }

  Future<void> removePost(PostDto post) async {
    await StorageService.removeFile(post.filePath);
    if (post.likesCount > 0) {
      QuerySnapshot likesSnapshot = await _firestore
        .collection('posts')
        .doc(post.id)
        .collection('likes')
        .get();
      await Future.wait(likesSnapshot.docs.map((likeDoc) =>
        likeDoc.reference.delete()
      ));
    }
    if (post.commentsCount > 0) {
      QuerySnapshot commentsSnapshot = await _firestore
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .get();
      await Future.wait(commentsSnapshot.docs.map((commentDoc) =>
        commentDoc.reference.delete()
      ));
    }
    await _firestore
      .collection('posts')
      .doc(post.id)
      .delete();
    return _firestore.runTransaction((Transaction tx) async {
      DocumentReference userRef = _firestore
        .collection('users')
        .doc(FirebaseService.getCurrentUserId());
      DocumentSnapshot userSnapshot = await tx.get(userRef);
      tx.update(userRef, {
        'postsCount': (userSnapshot.data() as Map)['postsCount'] - 1
      });
      return;
    });
  }

  Future<void> likePost(String postId) async {
    DocumentReference postRef = _firestore
      .collection('posts')
      .doc(postId);
    await postRef
      .collection('likes')
      .doc(FirebaseService.getCurrentUserId())
      .set({ 'date': DateTime.now() });
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      tx.update(postRef, {
        'likesCount': (postSnapshot.data() as Map)['likesCount'] + 1
      });
      return;
    });
  }

  Future<void> dislikePost(String postId) async {
    DocumentReference postRef = _firestore
      .collection('posts')
      .doc(postId);
    await postRef
      .collection('likes')
      .doc(FirebaseService.getCurrentUserId())
      .delete();
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      tx.update(postRef, {
        'likesCount': (postSnapshot.data() as Map)['likesCount'] - 1
      });
      return;
    });
  }

  Future<PostDto> _getPostByDoc(
    DocumentSnapshot postDoc,
    [UserDto? user]
  ) async {
    Map postData = postDoc.data() as Map;
    bool isLiked = false;
    if (postData['likesCount'] > 0) {
      DocumentSnapshot likeSnapshot = await _firestore
        .collection('posts')
        .doc(postDoc.id)
        .collection('likes')
        .doc(FirebaseService.getCurrentUserId())
        .get();
      isLiked = likeSnapshot.exists;
    }
    user ??= await _userService.getUser(postData['userId']);
    return PostDto.fromDoc(postDoc, user, isLiked);
  }

  Future<List<PostDto>> _getPostsByDocs(
    List<DocumentSnapshot> postDocs,
    int pageLimitCount,
    [UserDto? user]
  ) async {
    if (postDocs.isEmpty) {
      return [];
    }
    bool isLastPage = postDocs.length < (pageLimitCount + 1);
    if (postDocs.length > pageLimitCount) {
      postDocs = postDocs.sublist(0, pageLimitCount);
    }
    List<PostDto> posts = await Future.wait(postDocs.map((postDoc) =>
      _getPostByDoc(postDoc, user)
    ));
    if (isLastPage) {
      posts.last.docSnapshot = null;
    }
    return posts;
  }
}