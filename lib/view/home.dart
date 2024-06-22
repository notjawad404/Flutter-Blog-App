import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:flutter_blog_app/view/add_posts_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController(PostService()));

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find();
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search the Posts'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              child: const Text('Add Post')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter post title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    postController.searchPost(searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (postController.posts.isEmpty) {
                return const Center(child: Text('No posts found.'));
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: postController.posts.length,
                  itemBuilder: (context, index) {
                    final post = postController.posts[index];
                    return ListTile(
                      title: Text('${post.username}: ${post.title}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.content),
                          const SizedBox(height: 5),
                          Text(
                            'Date: ${post.date}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
