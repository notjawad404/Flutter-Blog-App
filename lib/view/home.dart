// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/view/add_posts_screen.dart';
import 'package:flutter_blog_app/view/authScreens/login_screen.dart';
import 'package:flutter_blog_app/view/user_posts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedPosts = json.decode(response.body);
        setState(() {
          posts = fetchedPosts;
          filteredPosts = fetchedPosts;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching posts: $error');
      }
    }
  }

  void filterPosts(String title) {
    setState(() {
      filteredPosts = posts
          .where((post) =>
              post['title'].toString().toLowerCase().contains(title.toLowerCase()))
          .toList();
    });
  }

    void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
            },
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPosts()));
          }, child: const Text('My Posts')),
          IconButton(onPressed: (){
            logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search by title',
              ),
              onChanged: (value) {
                setState(() {
                  title = value;
                  filterPosts(title);
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(post['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post['content']),
                          Text('By: ${post['username']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
