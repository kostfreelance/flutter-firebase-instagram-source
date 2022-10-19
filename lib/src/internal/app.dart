import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/login_screen.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/tabs_screen.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/register_screen.dart';
import 'package:flutter_firebase_instagram/src/presentation/screens/reset_password_screen.dart';

class App extends StatelessWidget {
  final String initialRoute;

  const App({
    Key? key,
    required this.initialRoute
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Instagram',
          theme: ThemeData(
            fontFamily: 'Lato-Regular',
            scaffoldBackgroundColor: AppColors.white
          ),
          initialRoute: initialRoute,
          getPages: [
            GetPage(
              name: LoginScreen.routeName,
              page: () => const LoginScreen()
            ),
            GetPage(
              name: RegisterScreen.routeName,
              page: () => const RegisterScreen()
            ),
            GetPage(
              name: ResetPasswordScreen.routeName,
              page: () => const ResetPasswordScreen() 
            ),
            GetPage(
              name: TabsScreen.routeName,
              page: () => const TabsScreen()
            )
          ]
        )
      )
    );
  }
}