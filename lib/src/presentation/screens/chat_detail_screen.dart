import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/message_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/chat_detail_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_progress_indicator.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_list_view.dart';
import 'profile_screen.dart';

class ChatDetailScreen extends StatelessWidget {
  final User user;
  final String? chatId;
  
  const ChatDetailScreen({
    Key? key,
    required this.user,
    this.chatId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatDetailController controller = Get.put(ChatDetailModule.controller(user, chatId));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: const AppNavBarBackButton(),
        title: _AppNavBarTitleBuilder(user)
      ),
      body: Column(
        children: [
          Obx(() =>
            _ListBuilder(
              scrollController: controller.scrollController,
              showInfinityLoader: controller.showInfinityLoader,
              items: controller.messages.value,
              fetchNextItems: controller.fetchNextMessages
            )
          ),
          Obx(() =>
            _BottomBarBuilder(
              isMessageValid: controller.isMessageValid.value,
              messageController: controller.messageController,
              onMessageChanged: controller.onMessageChanged,
              onSendPressed: controller.onSendPressed
            )
          )
        ]
      )
    );
  }
}

class _AppNavBarTitleBuilder extends StatelessWidget {
  final User user;

  const _AppNavBarTitleBuilder(
    this.user, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10.w),
              child: user.imageUrl.isNotEmpty ?
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.black,
                  backgroundImage: NetworkImage(user.imageUrl)
                ) :
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle
                  ),
                )
            ),
            Text(
              user.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: AppColors.black
              )
            )
          ]
        )
      ),
      onTap: () =>
        Get.to(ProfileScreen(user: user))
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final ScrollController scrollController;
  final bool showInfinityLoader;
  final List<Message>? items;
  final Function() fetchNextItems;

  const _ListBuilder({
    Key? key,
    required this.scrollController,
    required this.showInfinityLoader,
    required this.items,
    required this.fetchNextItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (items != null) ?
        items!.isNotEmpty ?
          InfinityListView<Message>(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            controller: scrollController,
            items: items!,
            itemWidget: (items, index) =>
              _ItemBuilder(
                content: items[index].content,
                date: (index == (items.length - 1)) || ((index > 0) &&
                  (items[index].user.id != items[index + 1].user.id)) ?
                    items[index].date : null,
                isCurrent: items[index].user.isCurrent,
                withoutTopBorders: (index < (items.length - 1)) &&
                  (items[index].user.id == items[index + 1].user.id),
                withoutBottomBorders: (index > 0) &&
                  (items[index].user.id == items[index - 1].user.id)
              ),
            showLoader: showInfinityLoader,
            fetchNextItems: fetchNextItems
          ) :
          Container() :
        const AppProgressIndicator()
    );
  }
}

class _ItemBuilder extends StatelessWidget {
  final String content;
  final String? date;
  final bool isCurrent;
  final bool withoutTopBorders;
  final bool withoutBottomBorders;

  const _ItemBuilder({
    Key? key,
    required this.content,
    required this.date,
    required this.isCurrent,
    required this.withoutTopBorders,
    required this.withoutBottomBorders
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (date != null) ?
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              date!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey
              )
            )
          ) :
          Container(),
        Align(
          alignment: isCurrent ?
            Alignment.centerRight :
            Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width - 60.w) * 0.7),
            decoration: BoxDecoration(
              color: isCurrent ?
                AppColors.blue :
                AppColors.lightGrey,
              borderRadius: BorderRadius.only(
                topLeft: withoutTopBorders ?
                  (isCurrent ? Radius.circular(10.r) : Radius.zero) :
                  Radius.circular(10.r),
                topRight: withoutTopBorders ?
                  (isCurrent ? Radius.zero : Radius.circular(10.r)) :
                  Radius.circular(10.r),
                bottomLeft: withoutBottomBorders ?
                  (isCurrent ? Radius.circular(10.r) : Radius.zero) :
                  Radius.circular(10.r),
                bottomRight: withoutBottomBorders ?
                  (isCurrent ? Radius.zero : Radius.circular(10.r)) :
                  Radius.circular(10.r)
              )
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 8.h
            ),
            margin: EdgeInsets.only(bottom: 8.h),
            child: Text(
              content,
              textWidthBasis: TextWidthBasis.longestLine,
              style: TextStyle(
                fontSize: 16.sp,
                color: isCurrent ?
                  AppColors.white : AppColors.black
              )
            )
          )
        )
      ]
    );
  }
}

class _BottomBarBuilder extends StatelessWidget {
  final bool isMessageValid;
  final TextEditingController messageController;
  final Function() onMessageChanged;
  final Function() onSendPressed;

  const _BottomBarBuilder({
    Key? key,
    required this.isMessageValid,
    required this.messageController,
    required this.onMessageChanged,
    required this.onSendPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.lightGrey)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.black
                ),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 12.h
                  )
                ),
                maxLines: null,
                controller: messageController,
                onChanged: (_) => onMessageChanged()
              )
            ),
            AppButton(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h
              ),
              borderRadius: BorderRadius.circular(20.r),
              onPressed: isMessageValid ?
                onSendPressed : null,
              child: Text(
                'Send',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.blue
                )
              )
            )
          ]
        )
      )
    );
  }
}