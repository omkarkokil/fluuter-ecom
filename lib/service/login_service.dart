import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/constants/constant.dart';

class LoginService {
  final Dio _dio = Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithGoogle() async {
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

        return {
          'success': true,
          'message': response.data,
        };
      } else {
        print('Error during Google sign-in: ${response.data}');
        return {
          'success': false,
          'message': 'Invalid credentials',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error: $error',
      };
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$api/api/auth/loginuser', // Replace with your API endpoint
        data: {
          'email': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token); // Save the token
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid credentials',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> decodeToken() async {
    try {
      String? token = await getToken();
      final jwt = JWT.verify(
          token!,
          SecretKey(
              secret_key)); // You can verify the token with a secret key if needed
      return jwt.payload; // Return the payload of the token
    } catch (e) {
      print('Error decoding token: $e');
      return {};
    }
  }

  // Method to retrieve the stored JWT token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token'); // Retrieve the token
  }

  // Method to clear the token (logout)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove the token
  }
}
