import 'package:flutter/material.dart';
import 'package:flutter_blog_app/view/authScreens/signup_screen.dart';
import 'package:get/get.dart';


void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterView(),
     
    );
  }
}
