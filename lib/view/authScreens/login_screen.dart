import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/auth_controller.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:flutter_blog_app/view/authScreens/signup_screen.dart';
import 'package:flutter_blog_app/view/home.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            Obx(() {
              if (authController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ElevatedButton(
                  onPressed: () {
                    authController.login(
                      emailController.text,
                      passwordController.text,
                    );
                    final postService = PostService();
                    Get.put(PostController(postService));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Login'),
                );
              }
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                 foregroundColor: Colors.white, backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Does not have an account? Register here'),
            ),
            Obx(() {
              if (authController.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    authController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Container();
              }
            }),
          ],
        ),
      ),
    );
  }
}
