// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:flutter_blog_app/view/authScreens/login_screen.dart';
import 'package:flutter_blog_app/view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data != null) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
