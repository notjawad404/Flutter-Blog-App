import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var errorMessage = ''.obs;

  Future<void> register(String username, String email, String password) async {
    isLoading(true);
    try {
      var response = await AuthService.registerUser(username, email, password);
      if (response['message'] == 'User registered successfully') {
        await _storeUsername(username);
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
        Get.snackbar('Success', 'Login successful',
            snackPosition: SnackPosition.BOTTOM);
        await _storeUsername(response['username']);
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

  Future<void> logout() async {
    isLoading(true);
    try {
      await AuthService.logout();
      isAuthenticated(false);
      await _clearLocalStorage();
    } catch (e) {
      errorMessage('Error logging out user: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _storeUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    print('Username stored: $username'); // Debugging line
  }

  Future<void> _clearLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('username');
    print('Local storage cleared'); // Debugging line
  }

  Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    print('Retrieved username: $username'); // Debugging line
    return username;
  }

  Future<void> checkAuthStatus() async {
    final String? token = await AuthService.getToken();
    isAuthenticated(token != null);
  }
}
