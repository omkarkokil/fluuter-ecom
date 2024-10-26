import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/service/login_service.dart';

class LoginProvider with ChangeNotifier {
  final LoginService _loginService = LoginService();

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  bool get isLoggedIn => _token != null;

  // Check if the user is already logged in by checking the stored token
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    notifyListeners(); // Notify UI to update
  }

  // Login method that interacts with the LoginService
  Future<bool> login(String username, String password) async {
    var result = await _loginService.login(username, password);

    if (result['success']) {
      _token = result['data']['token']; // Save token in provider
      notifyListeners(); // Notify UI
      return true;
    } else {
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove token from storage
    _token = null;
    notifyListeners(); // Notify UI to update
  }

  // Future<bool> login(String username, String password) async {
  //   _isLoading = true;
  //   notifyListeners(); // Notify listeners to show loading spinner

  //   final response = await _loginService.login(username, password);
  //   print(response);
  //   _isLoading = false;
  //   if (response['success']) {
  //     _errorMessage = null;
  //     notifyListeners();
  //     return true; // Login successful
  //   } else {
  //     _errorMessage = response['message'];
  //     notifyListeners();
  //     return false; // Login failed
  //   }
  // }
}
