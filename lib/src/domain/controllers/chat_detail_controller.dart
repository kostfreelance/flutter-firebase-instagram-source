import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/message_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_chat_repository.dart';

class ChatDetailController extends GetxController {
  final IChatRepository _chatRepository;
  final User _user;
  String? _chatId;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  StreamSubscription? _getMessagesSubscription;
  final isMessageValid = false.obs;
  final messages = Rxn<List<Message>>();

  bool get showInfinityLoader => messages.value != null &&
    messages.value!.isNotEmpty &&
    messages.value!.last.doc != null;

  ChatDetailController(
    this._chatRepository,
    this._user,
    this._chatId
  ) {
    _init();
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    _getMessagesSubscription?.cancel();
    super.onClose();
  }

  void _init() async {
    _chatId ??= await _chatRepository.getChatIdByUserId(_user.id);
    if (_chatId != null) {
      _getMessagesSubscription = _chatRepository
        .watchMessages(_chatId!, _user)
        .listen((newMessages) async {
          await _chatRepository.updateMemberLastVisitDate(_chatId!);
          messages.value = newMessages;
          await Future.delayed(const Duration(milliseconds: 300));
          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
        });
    } else {
      messages.value = [];
    }
  }

  void fetchNextMessages() async {
    if (_chatId != null && showInfinityLoader) {
      messages.value = messages.value! + (await _chatRepository.getMessages(
        _chatId!,
        _user,
        messages.value![messages.value!.length - 1].doc!
      ));
    }
  }
  
  void onMessageChanged() {
    isMessageValid.value = messageController.text.isNotEmpty;
  }

  void onSendPressed() async {
    String message = messageController.text;
    messageController.text = '';
    onMessageChanged();
    if (_chatId == null) {
      _chatId = await _chatRepository.createChat(_user.id);
      _init();
    }
    await _chatRepository.createMessage(_chatId!, message);
  }
}