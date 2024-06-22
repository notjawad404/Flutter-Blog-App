import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:get/get.dart';
import 'package:flutter_blog_app/models/postsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPostScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find();

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Post'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Add Post'),
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            SharedPreferences prefs = snapshot.data!;
            String? username = prefs.getString('username');

            return Scaffold(
              appBar: AppBar(
                title: const Text('Add Post'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(labelText: 'Content'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some content';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (kDebugMode) {
                              print(username);
                            }
                            if (username != null) {
                              Post newPost = Post(
                                username: username,
                                title: _titleController.text,
                                content: _contentController.text,
                                date: DateTime.now(),
                                id: '',
                              );
                              postController.addPost(newPost);
                              Get.back();
                            } else {
                              if (kDebugMode) {
                                print('Username not found');
                              }
                              Get.snackbar("Username not found",
                                  "make sure you are login first");
                            }
                          }
                        },
                        child: const Text('Add Post'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
