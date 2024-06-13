
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/view/add_posts_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad App1'),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
          }, child: const Text('Add Post'))
        ],
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
              );
            },
          );
        }
      }),
    );
  }
}
