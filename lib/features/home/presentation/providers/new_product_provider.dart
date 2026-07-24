import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../shared/data/models/product_model.dart';

class NewProductProvider extends ChangeNotifier {
  bool _getNewProductsInProgress = false;
  List<ProductModel> _productList = [];
  String? _errorMessage;

  bool get getNewProductsInProgress => _getNewProductsInProgress;
  List<ProductModel> get productList => _productList;
  String? get errorMessage => _errorMessage;

  Future<bool> getNewProducts() async {
    bool isSuccess = false;
    _getNewProductsInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(1, 10, tag: 'new'),
    );

    if (response.isSuccess) {
      List<ProductModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ProductModel.fromJson(jsonData));
      }
      if (list.isEmpty) {
        final NetworkResponse fallbackResponse = await getNetworkCaller().getRequest(
          Urls.productListUrl(3, 10),
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

    _getNewProductsInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
