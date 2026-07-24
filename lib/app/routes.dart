import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/verify_otp_screen.dart';
import '../features/products/presentation/screens/product_details_screen.dart';
import '../features/products/presentation/screens/product_list_by_category_screen.dart';
import '../features/shared/presentation/screens/main_nav_holder_screen.dart';

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget widget = SizedBox();

    switch (settings.name) {
      case SplashScreen.name:
        widget = SplashScreen();
      case SignInScreen.name:
        widget = SignInScreen();
      case SignUpScreen.name:
        widget = SignUpScreen();
      case VerifyOtpScreen.name:
        final email = settings.arguments as String;
        widget = VerifyOtpScreen(email: email);
      case MainNavHolderScreen.name:
        widget = MainNavHolderScreen();
      case ProductListByCategoryScreen.name:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widget = ProductListByCategoryScreen(
          categoryId: args['categoryId'],
          categoryName: args['categoryName'],
        );
      case ProductDetailsScreen.name:
        final String productId = settings.arguments as String;
        widget = ProductDetailsScreen(productId: productId);
    }

    return MaterialPageRoute(builder: (ctx) => widget);
  }
}