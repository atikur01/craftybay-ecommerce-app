import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/product_details_model.dart';

class ProductDetailsProvider extends ChangeNotifier {
  bool _getProductDetailsInProgress = false;

  String? _errorMessage;

  ProductDetailsModel? _productDetails;

  bool get getProductDetailsInProgress => _getProductDetailsInProgress;

  String? get errorMessage => _errorMessage;

  ProductDetailsModel? get productDetails => _productDetails;

  Future<bool> getProductDetails(String productId) async {
    bool isSuccess = false;

    _getProductDetailsInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productDetailsUrl(productId),
    );

    if (response.isSuccess) {
      _productDetails = ProductDetailsModel.fromJson(response.body['data']);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProductDetailsInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> getProductDetailsBySlug(String slug) async {
    bool isSuccess = false;

    _getProductDetailsInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productDetailsBySlugUrl(slug),
    );

    if (response.isSuccess) {
      _productDetails = ProductDetailsModel.fromJson(response.body['data']);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProductDetailsInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
