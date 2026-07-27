import 'package:flutter/material.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../category/data/models/category_model.dart';
import '../../../shared/data/models/product_model.dart';

class PopularProductProvider extends ChangeNotifier {
  bool _getPopularProductsInProgress = false;
  List<ProductModel> _productList = [];
  String? _errorMessage;

  bool get getPopularProductsInProgress => _getPopularProductsInProgress;
  List<ProductModel> get productList => _productList;
  String? get errorMessage => _errorMessage;

  Future<bool> getPopularProducts({String? categoryId}) async {
    bool isSuccess = false;
    _getPopularProductsInProgress = true;
    notifyListeners();

    String? targetCategoryId = categoryId;

    if (targetCategoryId == null) {
      final NetworkResponse categoryResponse = await getNetworkCaller().getRequest(
        Urls.categoryListUrl(1, 32),
      );

      if (categoryResponse.isSuccess && categoryResponse.body['data'] != null) {
        for (Map<String, dynamic> jsonData in categoryResponse.body['data']['results']) {
          CategoryModel category = CategoryModel.fromJson(jsonData);
          if (category.title.toLowerCase().contains('popular')) {
            targetCategoryId = category.id;
            break;
          }
        }
        if (targetCategoryId == null &&
            (categoryResponse.body['data']['results'] as List).isNotEmpty) {
          targetCategoryId =
              categoryResponse.body['data']['results'][0]['_id'];
        }
      }
    }

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(
        1,
        10,
        categoryId: targetCategoryId,
        tag: targetCategoryId == null ? 'popular' : null,
      ),
    );

    if (response.isSuccess) {
      List<ProductModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ProductModel.fromJson(jsonData));
      }
      if (list.isEmpty) {
        final NetworkResponse fallbackResponse =
            await getNetworkCaller().getRequest(
          Urls.productListUrl(1, 10),
        );
        if (fallbackResponse.isSuccess) {
          for (Map<String, dynamic> jsonData
              in fallbackResponse.body['data']['results']) {
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
