import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/chat_dto.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/user_dto.dart';
import 'package:flutter_firebase_instagram/src/data/dtos/message_dto.dart';
import 'firebase_service.dart';
import 'user_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final int _pageLimitCount = 15;

  Stream<List<ChatDto>> watchChats() {
    Query chatsQuery = _firestore
      .collection('chats')
      .orderBy('lastActivityDate', descending: true)
      .where('userIds', arrayContains: FirebaseService.getCurrentUserId());
    return chatsQuery.snapshots().map<QuerySnapshot>((el) => el).transform(
      StreamTransformer<QuerySnapshot, List<ChatDto>>
        .fromHandlers(handleData: (chatsSnapshot, sink) async {
          sink.add(await _getChatsByDocs(chatsSnapshot.docs));
        })
    );
  }

  Future<String?> getChatIdByUserId(String userId) async {
    String generatedChatId = _generateChatId([FirebaseService.getCurrentUserId(), userId]);
    DocumentSnapshot chatSnapshot = await _firestore
      .collection('chats')
      .doc(generatedChatId)
      .get();
    return chatSnapshot.exists ? generatedChatId : null;
  }

  Future<String> createChat(String userId) async {
    String? chatId = await getChatIdByUserId(userId);
    if (chatId == null) {
      List<String> userIds = [FirebaseService.getCurrentUserId(), userId];
      chatId = _generateChatId(userIds);
      DateTime nowDate = DateTime.now();
      DocumentReference chatRef = _firestore
        .collection('chats')
        .doc(chatId);
      await chatRef.set({
        'lastActivityDate': nowDate,
        'userIds': userIds
      });
      WriteBatch batch = _firestore.batch();
      for (String userId in userIds) {
        batch.set(
          chatRef.collection('members').doc(userId),
          { 'lastVisitDate': nowDate }
        );
      }
      await batch.commit();
    }
    return chatId;
  }

  Future<void> removeChat(String chatId) async {
    DocumentReference chatDocRef = _firestore
      .collection('chats')
      .doc(chatId);
    QuerySnapshot messagesSnapshot = await chatDocRef
      .collection('messages')
      .get();
    await Future.wait(messagesSnapshot.docs.map((messageDoc) =>
      messageDoc.reference.delete()
    ));
    QuerySnapshot membersSnapshot = await chatDocRef
      .collection('members')
      .get();
    await Future.wait(membersSnapshot.docs.map((memberDoc) =>
      memberDoc.reference.delete()
    ));
    return chatDocRef.delete();
  }

  Stream<List<MessageDto>> watchMessages(
    String chatId,
    UserDto user
  ) {
    Query messagesQuery = _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('date', descending: true)
      .limit(_pageLimitCount + 1);
    return messagesQuery.snapshots().map<QuerySnapshot>((el) => el).transform(
      StreamTransformer<QuerySnapshot, List<MessageDto>>
        .fromHandlers(handleData: (messagesSnapshot, sink) async {
          sink.add(await _getMessagesByDocsAndUser(messagesSnapshot.docs, user));
        })
    );
  }

  Future<List<MessageDto>> getMessages(
    String chatId,
    UserDto user,
    DocumentSnapshot docSnapshot
  ) async {
    Query messagesQuery = _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('date', descending: true)
      .startAfterDocument(docSnapshot)
      .limit(_pageLimitCount + 1);
    List<DocumentSnapshot> messageDocs = (await messagesQuery.get()).docs;
    return _getMessagesByDocsAndUser(messageDocs, user);
  }

  Future<void> createMessage(
    String chatId,
    String content
  ) async {
    await _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add({
        'content': content,
        'date': DateTime.now(),
        'userId': FirebaseService.getCurrentUserId()
      });
    return _firestore
      .collection('chats')
      .doc(chatId)
      .update({
        'lastActivityDate': DateTime.now()
      });
  }

  Future<void> updateMemberLastVisitDate(String chatId) async {
    Map<String, Object?> memberData = {
      'lastVisitDate': DateTime.now()
    };
    DocumentReference chatRef = _firestore
      .collection('chats')
      .doc(chatId);
    await chatRef
      .collection('members')
      .doc(FirebaseService.getCurrentUserId())
      .update(memberData);
    return chatRef.update(memberData);
  }

  Future<List<ChatDto>> _getChatsByDocs(
    List<DocumentSnapshot> chatDocs
  ) async {
    if (chatDocs.isEmpty) {
      return [];
    }

    List<String> chatIds = chatDocs.map((chatDoc) => chatDoc.id).toList();
    List<Map> chatDatas = chatDocs.map((chatDoc) => chatDoc.data() as Map).toList();

    String currentUserId = FirebaseService.getCurrentUserId();
    List<String> userIds = [];
    for (Map chatData in chatDatas) {
      for (String userId in chatData['userIds']) {
        if (userId != currentUserId) {
          userIds.add(userId);
        }
      }
    }
    List<UserDto> users = await _userService.getUsersByIds(userIds);
    
    List<MessageDto?> lastMessages = (await Future.wait(chatIds.map((chatId) async {
      QuerySnapshot messagesSnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
      return messagesSnapshot.docs.isNotEmpty ?
        messagesSnapshot.docs[0] : null;
    }))).asMap().map((messageDocIndex, messageDoc) =>
      MapEntry(
        messageDocIndex,
        (messageDoc != null) ?
          MessageDto.fromDoc(
            messageDoc, users[messageDocIndex]
          ) :
          null
      )
    ).values.toList();

    List<DateTime> lastVisitDates = await Future.wait(chatIds.map((chatId) async {
      DocumentSnapshot memberDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('members')
        .doc(currentUserId)
        .get();
      return memberDoc['lastVisitDate'].toDate();
    }));

    return chatDatas.asMap().map((chatDataIndex, chatData) => MapEntry(
      chatDataIndex, ChatDto(
        id: chatIds[chatDataIndex],
        user: users[chatDataIndex],
        lastMessage: lastMessages[chatDataIndex],
        hasUnreadMessages: (lastMessages[chatDataIndex] == null) ||
          (lastMessages[chatDataIndex]!.user.id != currentUserId) &&
          (lastMessages[chatDataIndex]!.date.isAfter(lastVisitDates[chatDataIndex])),
      )
    )).values.toList();
  }

  Future<List<MessageDto>> _getMessagesByDocsAndUser(
    List<DocumentSnapshot> messageDocs,
    UserDto user
  ) async {
    if (messageDocs.isEmpty) {
      return [];
    }
    bool isLastPage = messageDocs.length < (_pageLimitCount + 1);
    if (messageDocs.length > _pageLimitCount) {
      messageDocs = messageDocs.sublist(0, _pageLimitCount);
    }
    UserDto currentUser = await _userService.getCurrentUser();
    List<MessageDto> messages = messageDocs.map((messageDoc) =>
      MessageDto.fromDoc(
        messageDoc,
        ((messageDoc.data() as Map)['userId'] == user.id) ? user : currentUser
      )
    ).toList();
    if (isLastPage) {
      messages.last.docSnapshot = null;
    }
    return messages;
  }

  String _generateChatId(List<String> userIds) {
    userIds.sort((a, b) =>
      a.compareTo(b)
    );
    return userIds.join('');
  }
}