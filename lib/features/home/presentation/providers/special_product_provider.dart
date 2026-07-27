import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../shared/data/models/product_model.dart';

class SpecialProductProvider extends ChangeNotifier {
  bool _getSpecialProductsInProgress = false;
  List<ProductModel> _productList = [];
  String? _errorMessage;

  bool get getSpecialProductsInProgress => _getSpecialProductsInProgress;
  List<ProductModel> get productList => _productList;
  String? get errorMessage => _errorMessage;

  Future<bool> getSpecialProducts() async {
    bool isSuccess = false;
    _getSpecialProductsInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(1, 10, remark: 'special'),
    );

    bool hasData = response.isSuccess &&
        response.body != null &&
        response.body['data'] != null &&
        (response.body['data']['results'] as List).isNotEmpty;

    if (!hasData) {
      response = await getNetworkCaller().getRequest(
        Urls.productListUrl(1, 10, categoryId: AppConstants.specialCategoryId),
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

    _getSpecialProductsInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
