import 'package:crafty_bay/core/service/network_caller/network_caller.dart';
import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../data/models/sign_up_params.dart';

class SignUpProvider extends ChangeNotifier {
  bool _signUpInInProgress = false;

  bool get signUpInInProgress => _signUpInInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signUp(SignUpParams params) async {
    bool isSuccess = false;

    _signUpInInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.signUpUrl,
      body: params.toJson(),
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _signUpInInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
