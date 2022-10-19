import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/users_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/searchbar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_progress_indicator.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_list_tile.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_list_view.dart';
import 'profile_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen>
  with AutomaticKeepAliveClientMixin<UsersScreen> {
  late UsersController _usersController;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _usersController = Get.put(UsersModule.controller());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppNavBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: SearchBar(
            placeholder: 'Search for users',
            controller: _usersController.searchBarController,
            onChanged: _usersController.onSearchTermChanged
          )
        )
      ),
      body: Obx(() =>
        _ListBuilder(
          showInfinityLoader: _usersController.showInfinityLoader,
          items: _usersController.users.value,
          fetchNextItems: _usersController.fetchNextUsers,
          onRefresh: _usersController.fetchUsers
        )
      )
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final bool showInfinityLoader;
  final List<User>? items;
  final Function() fetchNextItems;
  final Function() onRefresh;

  const _ListBuilder({
    Key? key,
    required this.showInfinityLoader,
    required this.items,
    required this.fetchNextItems,
    required this.onRefresh
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (items != null) ?
      RefreshIndicator(
        onRefresh: () async {
          onRefresh();
          return Future.value();
        },
        child: items!.isNotEmpty ? 
          InfinityListView<User>(
            itemExtent: 65.h,
            padding: EdgeInsets.only(top: 7.5.h),
            items: items!,
            itemWidget: (items, index) =>
              _ItemBuilder(items[index]),
            showLoader: showInfinityLoader,
            fetchNextItems: fetchNextItems
          ) :
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: const NoDataLabel('No Users Yet')
                )
              ]
            )
          )
      ) :
      const AppProgressIndicator();
  }
}

class _ItemBuilder extends StatelessWidget {
  final User item;

  const _ItemBuilder(
    this.item, {
      Key? key
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
        onPressed: () =>
          Get.to(ProfileScreen(user: item))
      )
    );
  }
}