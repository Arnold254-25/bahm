import 'package:bahm/models/userModel.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:bahm/config/app_config.dart';

@lazySingleton
class AuthService {
  final Dio _dio = Dio();
  final Box _authBox;

  AuthService(@Named('authBox') this._authBox) {
    // Configure your API base URL here
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user';

  /// Logs in a user with email and password.
  /// Returns a UserModel on success.
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['user']);
        final token = response.data['token'] as String;

        // Store token and user data in Hive
        await _authBox.put(_tokenKey, token);
        await _authBox.put(_userKey, user);

        return user;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Validation error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Registers a new user with name, email, password, phone, and address.
  /// Returns a UserModel on success.
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    String imageUrl = 'https://example.com/default_image.png',
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
          'imageUrl': imageUrl,
        },
      );

      if (response.statusCode == 201) {
        final user = UserModel.fromJson(response.data['user']);
        final token = response.data['token'] as String;

        // Store token and user data in Hive
        await _authBox.put(_tokenKey, token);
        await _authBox.put(_userKey, user);

        return user;
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Validation error: ${e.response?.data}');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logs out the current user by clearing stored data.
  Future<void> logout() async {
    try {
      await _authBox.delete(_tokenKey);
      await _authBox.delete(_userKey);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Retrieves the stored authentication token.
  String? getToken() {
    return _authBox.get(_tokenKey) as String?;
  }

  /// Retrieves the stored user data.
  UserModel? getUser() {
    return _authBox.get(_userKey) as UserModel?;
  }

  /// Checks if the user is authenticated (has a valid token).
  bool isAuthenticated() {
    return getToken() != null;
  }

  /// Helper method to set authorization header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Helper method to clear authorization header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
