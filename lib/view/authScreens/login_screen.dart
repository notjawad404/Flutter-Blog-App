import 'package:flutter/material.dart';
import 'package:flutter_blog_app/Posts.dart';
import 'package:flutter_blog_app/controller/auth_controller.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (authController.isLoading.value) {
                return const CircularProgressIndicator();
              } else {
                return ElevatedButton(
                  onPressed: () {
                    authController.login(
                      emailController.text,
                      passwordController.text,
                    );
                     final postService = PostService();

                    Get.put(PostController(postService));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: const Text('Login'),
                );
              }
            }),
            Obx(() {
              if (authController.errorMessage.value.isNotEmpty) {
                return Text(
                  authController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
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