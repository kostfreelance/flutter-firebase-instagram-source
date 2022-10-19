import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/following_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_progress_indicator.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_list_tile.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_list_view.dart';

class FollowingScreen extends StatelessWidget {
  final String userId;
  
  const FollowingScreen({
    Key? key,
    required this.userId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowingController controller = Get.put(FollowingModule.controller(userId));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: const AppNavBarBackButton(),
        title: Obx(() =>
          AppNavBarTitle('${controller.followingCount.toString()} Following')
        )
      ),
      body: Obx(() =>
        _ListBuilder(
          showInfinityLoader: controller.showInfinityLoader,
          items: controller.users.value,
          fetchNextItems: controller.fetchNextFollowing,
          onItemPressed: controller.onUserPressed
        )
      )
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final bool showInfinityLoader;
  final List<User>? items;
  final Function() fetchNextItems;
  final Function(User) onItemPressed;

  const _ListBuilder({
    Key? key,
    required this.showInfinityLoader,
    required this.items,
    required this.fetchNextItems,
    required this.onItemPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (items != null) ?
      items!.isNotEmpty ?
        InfinityListView<User>(
          itemExtent: 65.h,
          padding: EdgeInsets.only(top: 7.5.h),
          items: items!,
          itemWidget: (items, index) =>
            _ItemBuilder(
              item: items[index],
              onItemPressed: onItemPressed
            ),
          showLoader: showInfinityLoader,
          fetchNextItems: fetchNextItems
        ) :
        const NoDataLabel('No Following Yet') :
      const AppProgressIndicator();
  }
}

class _ItemBuilder extends StatelessWidget {
  final User item;
  final Function(User) onItemPressed;

  const _ItemBuilder({
    Key? key,
    required this.item,
    required this.onItemPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: AppListTile(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        leading: Container(
          margin: EdgeInsets.only(right: 15.w),
          child: item.imageUrl.isNotEmpty ?
            CircleAvatar(
              radius: 25.h,
              backgroundColor: AppColors.black,
              backgroundImage: NetworkImage(item.imageUrl)
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
          item.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.black
          )
        ),
        onPressed: () => onItemPressed(item)
      )
    );
  }
}