import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_model.dart';

class AuthController {
  static final String _accessTokenKey = 'access-token';
  static final String _userKey = 'user';

  static String? accessToken;
  static UserModel? user;

  static Future<void> saveUserData(String token, UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userKey, jsonEncode(userModel.toJson()));

    user = userModel;
    accessToken = token;
  }

  static Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString(_accessTokenKey);
    user = UserModel.fromJson(
      jsonDecode(sharedPreferences.getString(_userKey)!),
    );
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey) != null;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_userKey);
  }
}
