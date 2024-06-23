import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  String? editPost;
  String title = '';
  String content = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    fetchPosts();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedPosts = json.decode(response.body);
        setState(() {
          posts = fetchedPosts;
          filteredPosts = fetchedPosts
              .where((post) =>
                  post['username'].toString().toLowerCase() == username.toLowerCase())
              .toList();
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  void handleEdit(post) {
    setState(() {
      editPost = post['_id'];
      title = post['title'];
      content = post['content'];
    });
  }

  Future<void> handleUpdate() async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/posts/$editPost'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'content': content}),
      );
      if (response.statusCode == 200) {
        final updatedPost = json.decode(response.body);
        setState(() {
          posts = posts.map((post) {
            if (post['_id'] == editPost) {
              return updatedPost;
            }
            return post;
          }).toList();
          editPost = null;
          title = '';
          content = '';
        });
      } else {
        throw Exception('Failed to update post');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating post: $error');
      }
    }
  }

  Future<void> handleDelete(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:5000/posts/$postId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          posts = posts.where((post) => post['_id'] != postId).toList();
          filteredPosts = filteredPosts.where((post) => post['_id'] != postId).toList();
        });
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (error) {
      print('Error deleting post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts by $username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (editPost == post['_id'])
                      Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                            controller: TextEditingController()..text = title,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Content',
                            ),
                            onChanged: (value) {
                              setState(() {
                                content = value;
                              });
                            },
                            controller: TextEditingController()..text = content,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: handleUpdate,
                                child: const Text('Update'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editPost = null;
                                  });
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post['username'],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(post['content']),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => handleEdit(post),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => handleDelete(post['_id']),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

