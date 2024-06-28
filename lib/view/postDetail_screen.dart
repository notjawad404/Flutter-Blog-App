import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map<String, dynamic>? post;
  List<dynamic> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPostAndComments();
  }

  Future<void> fetchPostAndComments() async {
    try {
      final postResponse =
          await http.get(Uri.parse('http://localhost:5000/posts'));
      final commentsResponse =
          await http.get(Uri.parse('http://localhost:5000/comments'));

      if (postResponse.statusCode == 200 &&
          commentsResponse.statusCode == 200) {
        final List<dynamic> fetchedPosts = json.decode(postResponse.body);
        final List<dynamic> fetchedComments =
            json.decode(commentsResponse.body);

        setState(() {
          post = fetchedPosts.firstWhere((post) => post['_id'] == widget.postId,
              orElse: () => null);
          comments = fetchedComments
              .where((comment) => comment['postid'] == widget.postId)
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts or comments');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching posts or comments: $error');
      }
    }
  }

  Future<void> addComment(String commentText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      
      if (username == null) {
        throw Exception('Username not found in SharedPreferences');
      }

      final response = await http.post(
        Uri.parse('http://localhost:5000/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'postid': widget.postId,
          'comments': commentText,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          comments.add(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error adding comment: $error');
      }
    }
  }

  void _showAddCommentDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final commentText = commentController.text;
                if (commentText.isNotEmpty) {
                  addComment(commentText);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : post == null
              ? const Center(child: Text('Post not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post!['title'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post!['content'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By: ${post!['username']}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddCommentDialog,
                        child: const Text('Add Comment'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Comments:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              child: ListTile(
                                title: Text(comment['comments']),
                                subtitle: Text('By: ${comment['username']}'),
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
