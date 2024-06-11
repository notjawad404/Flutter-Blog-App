import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/posts';

  Future<String> getHello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to load message');
    }
  }

  Future<Map<String, dynamic>> postData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
