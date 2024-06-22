import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:flutter_blog_app/view/add_posts_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController(PostService()));
  final TextEditingController searchController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Blog App')),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
              child: const Text('Add Post'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                labelText: 'Search by post title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    postController.searchPost(searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (postController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (postController.posts.isEmpty) {
                  return const Center(child: Text('No posts found.'));
                }

                return ListView.builder(
                  itemCount: postController.posts.length,
                  itemBuilder: (context, index) {
                    final post = postController.posts[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('${post.username}: ${post.title}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content),
                            const SizedBox(height: 5),
                            Text(
                              'Date: ${post.date}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
