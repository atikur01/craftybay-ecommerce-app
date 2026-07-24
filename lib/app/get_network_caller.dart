import 'package:flutter/material.dart';

import '../core/service/network_caller/network_caller.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import 'crafty_bay_app.dart';
import 'providers/auth_controller.dart';

NetworkCaller getNetworkCaller() {
  // Map<String, String> headers = {'content-type': 'application/json'};
  // if (AuthController.accessToken != null) {
  //   headers['token'] = AuthController.accessToken!;
  // }
  //
  // return NetworkCaller(headers: () => headers);

  return NetworkCaller(
    headers: () => {
      'content-type': 'application/json',
      if (AuthController.accessToken != null)
        'token': AuthController.accessToken!,
    },
    onUnauthorized: () async {
      // On user unauthorize
      await AuthController.clearUserData();
      Navigator.pushNamed(
        CraftyBayApp.navigatorKey.currentContext!,
        SignUpScreen.name,
      );
    },
  );
}

/// Uses
// NetworkResponse response = await getNetworkCaller().getRequest('url');
// if (response.isSuccess) {
//
// } else {
// response.errorMessage!
// }
