import 'package:flutter/material.dart';
import 'package:flutter_blog_app/controller/postsController.dart';
import 'package:flutter_blog_app/models/postsModel.dart';
import 'package:get/get.dart';

class SearchPostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find();

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                  
                    postController.searchPost(searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
        
                postController.searchPost(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (postController.posts.isEmpty) {
                return const Center(child: Text('No posts found.'));
              } else {
                return ListView.builder(
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
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
