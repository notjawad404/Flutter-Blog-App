import 'dart:convert';
import 'package:flutter_blog_app/models/postsModel.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl = 'http://localhost:5000';

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Search for a post by title
  Future<List<Post>> searchPost(String title) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?title=$title'));

    if (response.statusCode == 200) {
      // Assuming the server returns an array of posts
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
