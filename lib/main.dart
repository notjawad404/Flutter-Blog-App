import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/auth_controller.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:flutter_blog_app/view/authScreens/signup_screen.dart';
import 'package:flutter_blog_app/view/home.dart';
import 'package:get/get.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Get.lazyPut<AuthController>(
      () => AuthController(AuthService(), navigatorKey));
  Get.put(PostController(PostService()));

  runApp(MyApp(navigatorKey));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    authController.checkAuthStatus();

    return GetMaterialApp(
      title: 'Notepad App',
      home: SignupScreen(),
    );
  }
}
