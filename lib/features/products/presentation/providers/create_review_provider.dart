import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';

class CreateReviewProvider extends ChangeNotifier {
  bool _createReviewInProgress = false;
  String? _errorMessage;

  bool get createReviewInProgress => _createReviewInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> createReview(String productId, String comment, {double rating = 5.0}) async {
    bool isSuccess = false;
    _createReviewInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'product': productId,
      'comment': comment,
      'rating': rating.toInt().toString(),
    };

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.createReviewUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _createReviewInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
