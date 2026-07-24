import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
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

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(1, 10, tag: 'popular'),
    );

    if (response.isSuccess) {
      List<ProductModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ProductModel.fromJson(jsonData));
      }
      if (list.isEmpty) {
        final NetworkResponse fallbackResponse = await getNetworkCaller().getRequest(
          Urls.productListUrl(1, 10),
        );
        if (fallbackResponse.isSuccess) {
          for (Map<String, dynamic> jsonData in fallbackResponse.body['data']['results']) {
            list.add(ProductModel.fromJson(jsonData));
          }
        }
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
