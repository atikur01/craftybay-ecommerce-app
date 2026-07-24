import 'package:crafty_bay/core/service/network_caller/network_caller.dart';
import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/providers/auth_controller.dart';
import '../../../../app/urls.dart';
import '../../data/models/user_model.dart';
import '../../data/models/verify_otp_params.dart';

class VerifyOtpProvider extends ChangeNotifier {
  bool _verifyOtpInProgress = false;

  bool get verifyOtpInProgress => _verifyOtpInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> verifyOtp(VerifyOtpParams params) async {
    bool isSuccess = false;

    _verifyOtpInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.verifyOtpUrl,
      body: params.toJson(),
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
      String token = response.body['data']['token'];
      UserModel userModel = UserModel.fromJson(response.body['data']['user']);
      await AuthController.saveUserData(token, userModel);
    } else {
      _errorMessage = response.errorMessage;
    }

    _verifyOtpInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
