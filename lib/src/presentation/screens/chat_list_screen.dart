import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/chat_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/chat_list_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/searchbar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_progress_indicator.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_list_tile.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen>
  with AutomaticKeepAliveClientMixin<ChatListScreen> {
  late ChatListController _chatListController;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _chatListController = Get.put(ChatListModule.controller());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppNavBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: SearchBar(
            placeholder: 'Search for chats',
            controller: _chatListController.searchBarController,
            onChanged: _chatListController.onSearchTermChanged
          )
        )
      ),
      body: Obx(() =>
        _ListBuilder(
          chats: _chatListController.chats.value,
          onRemovePressed: _chatListController.onRemovePressed
        )
      )
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final List<Chat>? chats;
  final Function(String) onRemovePressed;

  const _ListBuilder({
    Key? key,
    required this.chats,
    required this.onRemovePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (chats != null) ?
      chats!.isNotEmpty ?
        ListView.builder(
          itemExtent: 65.h,
          padding: EdgeInsets.only(top: 7.5.h),
          itemCount: chats!.length,
          itemBuilder: (_, index) =>
            _ItemBuilder(
              item: chats![index],
              onRemovePressed: () =>
                onRemovePressed(chats![index].id)
            )
        ) :
        const NoDataLabel('No Chats Yet') :
      const AppProgressIndicator();
  }
}

class _ItemBuilder extends StatelessWidget {
  final Chat item;
  final Function() onRemovePressed;

  const _ItemBuilder({
    Key? key,
    required this.item,
    required this.onRemovePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              icon: Icons.delete_outline,
              onPressed: (context) {
                Slidable.of(context)?.close();
                onRemovePressed();
              }
            )
          ],
        ),
        child: AppListTile(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          leading: Container(
            margin: EdgeInsets.only(right: 15.w),
            child: item.user.imageUrl.isNotEmpty ?
              CircleAvatar(
                radius: 25.h,
                backgroundColor: AppColors.black,
                backgroundImage: NetworkImage(item.user.imageUrl)
              ) :
              Container(
                width: 50.h,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle
                )
              )
          ),
          title: Text(
            item.user.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black
            )
          ),
          subTitle: Row(
            children: [
              Flexible(
                child: Text(
                  (item.lastMessage != null) ?
                    item.lastMessage!.content : '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey
                  )
                )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                width: 2.r,
                height: 2.r,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              Flexible(
                child: Text(
                  (item.lastMessage != null) ?
                    item.lastMessage!.date : '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.lightGrey
                  )
                )
              )
            ]
          ),
          trailing: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: item.hasUnreadMessages ?
              Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
              ) :
              Container()
          ),
          onPressed: () =>
            Get.to(ChatDetailScreen(
              user: item.user,
              chatId: item.id
            ))
        )
      )
    );
  }
}