// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/view/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  _addPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse('http://localhost:5000/posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'title': title,
            'content': content,
          }),
        );

        if (response.statusCode == 201) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          throw Exception('Failed to add post');
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error adding post: $error');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding post: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                onSaved: (value) => content = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addPost,
                child: const Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
