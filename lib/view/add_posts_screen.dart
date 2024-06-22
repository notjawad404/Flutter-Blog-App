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

  AddPostScreen({Key? key}) : super(key: key);

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12.0),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
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
                              Get.snackbar(
                                "Username not found",
                                "Make sure you are logged in first",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16.0),
                                borderRadius: 10.0,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
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
