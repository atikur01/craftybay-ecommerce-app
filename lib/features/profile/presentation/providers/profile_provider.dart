import 'package:crafty_bay/app/get_network_caller.dart';
import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/app/urls.dart';
import 'package:crafty_bay/core/service/network_caller/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  UserModel? _userModel = AuthController.user;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  UserModel? get userModel => _userModel ?? AuthController.user;

  Future<bool> getProfileData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.profileUrl,
    );

    bool isSuccess = false;
    if (response.isSuccess && response.body != null && response.body['data'] != null) {
      _userModel = UserModel.fromJson(response.body['data']);
      if (AuthController.accessToken != null) {
        await AuthController.saveUserData(AuthController.accessToken!, _userModel!);
      }
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to load profile';
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String city,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'city': city,
    };

    final NetworkResponse response = await getNetworkCaller().patchRequest(
      Urls.profileUrl,
      body: requestBody,
    );

    bool isSuccess = false;
    if (response.isSuccess && response.body != null && response.body['data'] != null) {
      _userModel = UserModel.fromJson(response.body['data']);
      if (AuthController.accessToken != null) {
        await AuthController.saveUserData(AuthController.accessToken!, _userModel!);
      }
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to update profile';
    }

    _isUpdating = false;
    notifyListeners();
    return isSuccess;
  }
}
