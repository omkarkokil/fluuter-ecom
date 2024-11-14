import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/service/login_service.dart';

class LoginProvider with ChangeNotifier {
  final LoginService _loginService = LoginService();

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  bool get isLoggedIn => _token != null;

  final Dio _dio = Dio();

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

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      var googleUser = await googleSignIn.signIn();
      print(googleUser);

      final response = await _dio.post(
        '$api/api/auth/googleAuth',
        data: {
          'email': googleUser!.email,
          'name': googleUser.displayName,
          'picture': googleUser.photoUrl,
          'sub': googleUser.id,
        },
      );
      if (response.statusCode == 200) {
        final String token = response.data['token'];
        print(response.data['token']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token); // Save the token

        Fluttertoast.showToast(
            msg: 'You have successfully logged in', // Your message
            toastLength: Toast.LENGTH_SHORT, // Length of the toast
            gravity: ToastGravity.BOTTOM, // Position of the toast
            timeInSecForIosWeb: 1, // Duration in seconds for iOS and web
            backgroundColor: Colors.black, // Background color
            textColor: Colors.white, // Text color
            fontSize: 16.0 // Font size
            );

        return true;
      } else {
        print('Error during Google sign-in: ${response.data}');
        return false;
      }
    } catch (error) {
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

  Future<Map<String, dynamic>> userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      try {
        print(token);
        final jwt = JWT.verify(token, SecretKey(secret_key));
        return jwt.payload;
      } catch (e) {
        print('Error decoding token: $e');
        return {};
      }
    }
    return {};
  }
}
