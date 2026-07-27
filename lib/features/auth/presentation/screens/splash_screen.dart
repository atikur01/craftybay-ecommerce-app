import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/presentation/screens/main_nav_holder_screen.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if (await AuthController.isLoggedIn()) {
      await AuthController.loadUserData();
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, MainNavHolderScreen.name, (predicate) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(child: AppLogo()),
          Spacer(),
          Column(
            spacing: 16,
            children: [
              CircularProgressIndicator(),
              Text('${AppLocalizations.of(context)?.version} 1.0.0'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
