import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../shared/data/models/product_model.dart';

class ProductListProvider extends ChangeNotifier {
  final int _productsPerPage = 32;

  bool _isInitialLoading = false;

  bool _isLoadingMore = false;

  String? _errorMessage;

  int? _lastPage;

  int _currentPage = 0;

  final List<ProductModel> _productList = [];

  bool get isInitialLoading => _isInitialLoading;

  bool get isLoadingMore => _isLoadingMore;

  String? get errorMessage => _errorMessage;

  List<ProductModel> get productList => _productList;

  Future<bool> getProductData({
    String? categoryId,
    String? brandId,
    String? tag,
    String? remark,
  }) async {
    bool isSuccess = false;

    if (_currentPage == 0 || (_lastPage != null && _currentPage < _lastPage!)) {
      _currentPage++;
    } else {
      return false;
    }

    if (_currentPage == 1) {
      _isInitialLoading = true;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.productListUrl(
        _currentPage,
        _productsPerPage,
        categoryId: categoryId,
        brandId: brandId,
        tag: tag,
        remark: remark,
      ),
    );

    if (_currentPage == 1 &&
        remark != null &&
        categoryId != null &&
        (!response.isSuccess ||
            response.body == null ||
            response.body['data'] == null ||
            (response.body['data']['results'] as List).isEmpty)) {
      response = await getNetworkCaller().getRequest(
        Urls.productListUrl(
          _currentPage,
          _productsPerPage,
          categoryId: categoryId,
          brandId: brandId,
          tag: tag,
        ),
      );
    }

    if (response.isSuccess &&
        response.body != null &&
        response.body['data'] != null) {
      List<ProductModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(ProductModel.fromJson(jsonData));
      }
      _productList.addAll(list);
      _lastPage = response.body['data']['last_page'];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    if (_currentPage == 1) {
      _isInitialLoading = false;
    } else {
      _isLoadingMore = false;
    }
    notifyListeners();

    return isSuccess;
  }

  void refreshProductList() {
    _currentPage = 0;
    _lastPage = null;
    _productList.clear();
    getProductData();
  }

  bool get isLoading => _isInitialLoading || _isLoadingMore;
}
