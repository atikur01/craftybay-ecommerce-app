import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../shared/data/models/product_model.dart';

class PopularProductProvider extends ChangeNotifier {
  bool _getPopularProductsInProgress = false;
  List<ProductModel> _productList = [];
  String? _errorMessage;

  bool get getPopularProductsInProgress => _getPopularProductsInProgress;
  List<ProductModel> get productList => _productList;
  String? get errorMessage => _errorMessage;

  Future<bool> getPopularProducts() async {
    bool isSuccess = false;
    _getPopularProductsInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(1, 10, remark: 'popular'),
    );

    bool hasData = response.isSuccess &&
        response.body != null &&
        response.body['data'] != null &&
        (response.body['data']['results'] as List).isNotEmpty;

    if (!hasData) {
      response = await getNetworkCaller().getRequest(
        Urls.productListUrl(1, 10, categoryId: AppConstants.popularCategoryId),
      );
    }

    if (response.isSuccess &&
        response.body != null &&
        response.body['data'] != null) {
      List<ProductModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ProductModel.fromJson(jsonData));
      }
      _productList = list;
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getPopularProductsInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
