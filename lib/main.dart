import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:flutter_blog_app/view/home.dart';
import 'package:get/get.dart';


void main() {
  Get.put(PostController(PostService()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notepad App',
      home: HomeScreen(),
    );
  }
}
