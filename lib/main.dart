// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:flutter_blog_app/view/authScreens/login_screen.dart';
import 'package:flutter_blog_app/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data != null) {
            return const HomeScreen();
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
