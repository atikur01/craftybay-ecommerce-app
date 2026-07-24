import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/category_model.dart';

class CategoryListProvider extends ChangeNotifier {
  final int _categoryPerPage = 32;

  bool _isInitialLoading = false;

  bool _isLoadingMore = false;

  String? _errorMessage;

  int? _lastPage;

  int _currentPage = 0;

  final List<CategoryModel> _categoryList = [];

  bool get isInitialLoading => _isInitialLoading;

  bool get isLoadingMore => _isLoadingMore;

  String? get errorMessage => _errorMessage;

  List<CategoryModel> get categoryList => _categoryList;

  Future<bool> getCategoryData() async {
    bool isSuccess = false;

    // Current page is greater than last or is that initial page
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

    // Load data from API
    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.categoryListUrl(_currentPage, _categoryPerPage),
    );
    if (response.isSuccess) {
      List<CategoryModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(CategoryModel.fromJson(jsonData));
      }
      _categoryList.addAll(list);
      _lastPage = response.body['data']['last_page'];
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

  void refreshCategoryList() {
    _currentPage = 0;
    _lastPage = null;
    _categoryList.clear();
    getCategoryData();
  }

  bool get isLoading => _isInitialLoading || _isLoadingMore;
}
