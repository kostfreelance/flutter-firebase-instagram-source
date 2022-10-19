import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/tabs_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'home_screen.dart';
import 'users_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class TabsScreen extends StatelessWidget {
  static const routeName = '/tabs';

  const TabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabsController controller = Get.put(TabsModule.controller());
    List<IconData> icons = [
      Icons.home,
      Icons.search,
      Icons.add_a_photo,
      Icons.question_answer,
      Icons.person
    ];
    int postAddScreenIndex = 2;
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          const HomeScreen(),
          const UsersScreen(),
          Container(),
          const ChatListScreen(),
          const ProfileScreen()
        ]
      ),
      bottomNavigationBar: Container(
        color: AppColors.veryLightGrey,
        child: SafeArea(
          child: SizedBox(
            height: 45.h,
            child: Row(
              children: icons.asMap().map((itemIndex, item) =>
                MapEntry(
                  itemIndex,
                  Obx(() =>
                    _ItemBuilder(
                      icon: item,
                      selected: itemIndex == controller.pageIndex.value,
                      onPressed: () =>
                        controller.onTabPressed(itemIndex, postAddScreenIndex)
                    )
                  )
                )
              ).values.toList()
            )
          )
        )
      )
    );
  }
}

class _ItemBuilder extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  const _ItemBuilder({
    Key? key,
    required this.icon,
    required this.selected,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Icon(
              icon,
              size: 25.r,
              color: selected ?
                AppColors.black :
                AppColors.grey
            )
          )
        )
      )
    );
  }
}