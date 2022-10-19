import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/domain/models/chat_model.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/i_chat_repository.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/loader.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/confirm_alert.dart';

class ChatListController extends GetxController {
  final IChatRepository _chatRepository;
  final TextEditingController searchBarController = TextEditingController(); 
  StreamSubscription? _getChatsSubscription;
  List<Chat>? defaultChats;
  final chats = Rxn<List<Chat>>();

  ChatListController(this._chatRepository) {
    _init();
  }

  @override
  void onClose() {
    searchBarController.dispose();
    _getChatsSubscription?.cancel();
    super.onClose();
  }

  void _init() async {
    _getChatsSubscription?.cancel();
    _getChatsSubscription = _chatRepository
      .watchChats()
      .listen((newChats) {
        defaultChats = newChats;
        chats.value = List.from(defaultChats!);
      });
  }

  void onSearchTermChanged() async {
    if (defaultChats != null) {
      if (searchBarController.text.isNotEmpty) {
        chats.value = defaultChats!.where((chat) =>
          chat.user.name.contains(searchBarController.text.toLowerCase())
        ).toList();
      } else {
        chats.value = List.from(defaultChats!);
      }
    }
  }

  void onRemovePressed(String chatId) {
    ConfirmAlert.open(
      'Are you sure you want to delete this chat?',
      onConfirm: () async {
        Loader.open();
        try {
          await _chatRepository.removeChat(chatId);
          chats.value!.removeWhere((chat) =>
            chat.id == chatId
          );
          chats.refresh();
        } finally {
          Loader.close();
        }
      }
    );
  }
}