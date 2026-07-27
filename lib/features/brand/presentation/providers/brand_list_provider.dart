import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/brand_model.dart';

class BrandListProvider extends ChangeNotifier {
  final int _brandsPerPage = 32;

  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _isDetailsLoading = false;
  String? _errorMessage;
  int? _lastPage;
  int _currentPage = 0;

  final List<BrandModel> _brandList = [];
  BrandModel? _selectedBrand;

  bool get isInitialLoading => _isInitialLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isDetailsLoading => _isDetailsLoading;
  String? get errorMessage => _errorMessage;
  List<BrandModel> get brandList => _brandList;
  BrandModel? get selectedBrand => _selectedBrand;

  Future<bool> getBrandData() async {
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

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.brandListUrl(_currentPage, _brandsPerPage),
    );

    if (response.isSuccess) {
      List<BrandModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(BrandModel.fromJson(jsonData));
      }
      _brandList.addAll(list);
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

  Future<BrandModel?> getBrandDetails(String brandId) async {
    _isDetailsLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.readBrandUrl(brandId),
    );

    if (response.isSuccess && response.body['data'] != null) {
      _selectedBrand = BrandModel.fromJson(response.body['data']);
    } else {
      _errorMessage = response.errorMessage;
    }

    _isDetailsLoading = false;
    notifyListeners();
    return _selectedBrand;
  }

  void refreshBrandList() {
    _currentPage = 0;
    _lastPage = null;
    _brandList.clear();
    getBrandData();
  }

  bool get isLoading => _isInitialLoading || _isLoadingMore;
}
