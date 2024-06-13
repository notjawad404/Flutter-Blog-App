import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var errorMessage = ''.obs;

  Future<void> register(String username, String email, String password) async {
    isLoading(true);
    try {
      var response = await AuthService.registerUser(username, email, password);
      if (response['message'] == 'User registered successfully') {
        isAuthenticated(true);
      } else {
        errorMessage(response['message']);
      }
    } catch (e) {
      errorMessage('Error registering user: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      var response = await AuthService.loginUser(email, password);
      if (response['message'] == 'Login successful') {
        isAuthenticated(true);
      } else {
        errorMessage(response['message']);
      }
    } catch (e) {
      errorMessage('Error logging in user: $e');
    } finally {
      isLoading(false);
    }
  }
}
