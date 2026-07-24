import 'package:crafty_bay/features/wishlist/data/models/wishlist_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';

class WishListProvider extends ChangeNotifier {
  final int _productsPerPage = 32;

  bool _isInitialLoading = false;

  bool _isLoadingMore = false;

  String? _errorMessage;

  int? _lastPage;

  int _currentPage = 0;

  final List<WishlistModel> _wishListItems = [];

  bool get isInitialLoading => _isInitialLoading;

  bool get isLoadingMore => _isLoadingMore;

  String? get errorMessage => _errorMessage;

  List<WishlistModel> get productList => _wishListItems;

  Future<bool> getWishlistData() async {
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
      Urls.wishlistUrl(_currentPage, _productsPerPage),
    );
    if (response.isSuccess) {
      List<WishlistModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']['results']) {
        list.add(WishlistModel.fromJson(jsonData));
      }
      _wishListItems.addAll(list);
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
    _wishListItems.clear();
    getWishlistData();
  }

  bool get isLoading => _isInitialLoading || _isLoadingMore;
}
