import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/products/data/models/review_model.dart';
import 'package:crafty_bay/features/products/presentation/providers/review_list_provider.dart';
import 'package:crafty_bay/features/products/presentation/screens/create_review_screen.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key, required this.productId});

  static const String name = '/reviews-list';

  final String productId;

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final ReviewListProvider _reviewListProvider = ReviewListProvider();

  @override
  void initState() {
    super.initState();
    _reviewListProvider.getReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _reviewListProvider,
      child: Scaffold(
        appBar: AppBar(title: const Text('Reviews')),
        body: Consumer<ReviewListProvider>(
          builder: (context, reviewListProvider, _) {
            if (reviewListProvider.getReviewsInProgress) {
              return CenteredProcessIndicator();
            }

            if (reviewListProvider.reviewList.isEmpty) {
              return const Center(
                child: Text(
                  'No reviews available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reviewListProvider.reviewList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildReviewCard(reviewListProvider.reviewList[index]);
              },
            );
          },
        ),
        bottomNavigationBar: Consumer<ReviewListProvider>(
          builder: (context, reviewListProvider, _) {
            final totalReviews = reviewListProvider.reviewList.length;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.themeColor.withAlpha(25),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews ($totalReviews)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: _onTapAddReview,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.themeColor,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    String fullName = '${review.userFirstName} ${review.userLastName}'.trim();
    if (fullName.isEmpty) {
      fullName = 'Anonymous User';
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapAddReview() async {
    if (await AuthController.isLoggedIn() == false) {
      if (!mounted) return;
      Navigator.pushNamed(context, SignInScreen.name);
      return;
    }

    if (!mounted) return;

    final bool? refreshed = await Navigator.pushNamed(
      context,
      CreateReviewScreen.name,
      arguments: widget.productId,
    ) as bool?;

    if (refreshed == true) {
      _reviewListProvider.getReviews(widget.productId);
    }
  }
}
