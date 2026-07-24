import 'package:flutter/foundation.dart';
import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';

class ResendOtpProvider extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> resendOtp(String email) async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.resendOtpUrl,
      body: {'email': email},
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to resend OTP';
    }

    _inProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
