import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService {
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedPosts = json.decode(response.body);
        return fetchedPosts.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      rethrow;
    }
  }
}
