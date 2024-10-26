import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/constants/constant.dart';

class LoginService {
  final Dio _dio = Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      );
      var googleUser = await googleSignIn.signIn();
      print(googleUser);

      final response = await _dio.post(
        'http://192.168.88.86:5000/api/auth/googleAuth',
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
        await prefs.setString('jwt_token', token); // Store the token
      } else {
        throw Exception('Failed to log in with Google');
      }
    } catch (error) {
      print('Error during Google sign-in: $error');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'http://192.168.88.86:5000/api/auth/loginuser', // Replace with your API endpoint
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

  Map<String, dynamic> decodeToken(String token) {
    try {
      final jwt = JWT.verify(
          token,
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
