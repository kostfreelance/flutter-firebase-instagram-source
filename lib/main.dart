import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/data/services/firebase_service.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/auth_module.dart';
import 'package:flutter_firebase_instagram/src/internal/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  runApp(App(initialRoute: await Get.put(AuthModule.controller()).getInitialRoute()));
}