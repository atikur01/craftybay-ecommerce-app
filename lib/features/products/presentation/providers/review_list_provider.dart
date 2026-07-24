import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/review_model.dart';

class ReviewListProvider extends ChangeNotifier {
  bool _getReviewsInProgress = false;
  List<ReviewModel> _reviewList = [];
  String? _errorMessage;

  bool get getReviewsInProgress => _getReviewsInProgress;
  List<ReviewModel> get reviewList => _reviewList;
  String? get errorMessage => _errorMessage;

  Future<bool> getReviews(String productId) async {
    bool isSuccess = false;
    _getReviewsInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.reviewListUrl(productId),
    );

    if (response.isSuccess) {
      List<ReviewModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ReviewModel.fromJson(jsonData));
      }
      _reviewList = list;
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getReviewsInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
