import 'package:flutter/material.dart';

import '../core/service/network_caller/network_caller.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import 'crafty_bay_app.dart';
import 'providers/auth_controller.dart';

NetworkCaller getNetworkCaller() {
  return NetworkCaller(
    headers: () => {
      'content-type': 'application/json',
      if (AuthController.accessToken != null)
        'token': AuthController.accessToken!,
    },
    onUnauthorized: () async {
      await AuthController.clearUserData();
      Navigator.pushNamed(
        CraftyBayApp.navigatorKey.currentContext!,
        SignInScreen.name,
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
