import 'package:crafty_bay/features/auth/data/models/sign_in_params.dart';
import 'package:crafty_bay/features/auth/presentation/providers/sign_in_provider.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:crafty_bay/features/shared/presentation/screens/main_nav_holder_screen.dart';
import 'package:crafty_bay/features/shared/presentation/utils/validators.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/extensions/localization_extension.dart';
import '../widgets/app_logo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignInProvider _signInProvider = SignInProvider();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return ChangeNotifierProvider.value(
      value: _signInProvider,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const .all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: .onUserInteraction,
                onChanged: () {},
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    AppLogo(width: 100),
                    const SizedBox(height: 16),
                    Text('Welcome Back', style: textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in with your email and password',
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      textInputAction: .next,
                      keyboardType: .emailAddress,
                      decoration: InputDecoration(
                        labelText: context.localization.email,
                        hintText: context.localization.email,
                      ),
                      validator: (String? value) =>
                          Validators.validateEmail(value),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        labelText: context.localization.password,
                        hintText: context.localization.password,
                      ),
                      validator: (input) => Validators.validatePassword(input),
                    ),
                    const SizedBox(height: 16),
                    Consumer<SignInProvider>(
                      builder: (context, _, _) {
                        if (_signInProvider.signInProgress) {
                          return CenteredProcessIndicator();
                        }

                        return FilledButton(
                          onPressed: _onTapSignInButton,
                          child: Text('Sign in'),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _onTapSignUpButton,
                      child: Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    SignInParams params = SignInParams(
      email: _emailTEController.text.trim(),
      password: _passwordTEController.text,
    );

    final isSuccess = await _signInProvider.signIn(params);
    if (mounted == false) {
      return;
    }
    if (isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavHolderScreen.name,
        (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, _signInProvider.errorMessage!);
    }
  }

  void _onTapSignUpButton() {
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
