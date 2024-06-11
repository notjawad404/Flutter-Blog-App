import 'package:flutter/material.dart';
import 'package:flutter_blog_app/service/auth_service.dart';
import 'package:flutter_blog_app/view/authScreens/login_screen.dart';
import 'package:flutter_blog_app/view/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthService authService;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthController(this.authService, this.navigatorKey);

  var isLoading = false.obs;
  var isAuthenticated = false.obs;

  void signUp(String username, String password) async {
    try {
      isLoading(true);
      String token = await authService.signUp(username, password);
      await _saveToken(token);
      isAuthenticated(true);
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void login(String username, String password) async {
    try {
      isLoading(true);
      String token = await authService.login(username, password);
      await _saveToken(token);
      isAuthenticated(true);
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _removeToken();
    isAuthenticated(false);
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> checkAuthStatus() async {
    String? token = await _getToken();
    if (token != null) {
      isAuthenticated(true);
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
