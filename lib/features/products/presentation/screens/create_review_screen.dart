import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/features/products/presentation/providers/create_review_provider.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key, required this.productId});

  static const String name = '/create-review';

  final String productId;

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _reviewTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateReviewProvider _createReviewProvider = CreateReviewProvider();

  @override
  void initState() {
    super.initState();
    _firstNameTEController.text = AuthController.user?.firstName ?? '';
    _lastNameTEController.text = AuthController.user?.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _createReviewProvider,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Review')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                spacing: 16,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _reviewTEController,
                    maxLines: 6,
                    decoration: const InputDecoration(hintText: 'Write Review'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your review comment';
                      }
                      return null;
                    },
                  ),
                  Consumer<CreateReviewProvider>(
                    builder: (context, provider, _) {
                      if (provider.createReviewInProgress) {
                        return CenteredProcessIndicator();
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onTapSubmit,
                          child: const Text('Submit'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSubmit() async {
    if (_formKey.currentState!.validate()) {
      final isSuccess = await _createReviewProvider.createReview(
        widget.productId,
        _reviewTEController.text.trim(),
      );

      if (!mounted) return;

      if (isSuccess) {
        showSnackBarMessage(context, 'Review posted successfully');
        Navigator.pop(context, true);
      } else {
        showSnackBarMessage(
          context,
          _createReviewProvider.errorMessage ?? 'Failed to post review',
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _reviewTEController.dispose();
    super.dispose();
  }
}
