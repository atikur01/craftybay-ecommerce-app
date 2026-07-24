import 'package:crafty_bay/features/shared/data/models/product_model.dart';
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

  bool isProductInWishlist(String productId) {
    return _wishListItems.any((item) => item.productModel.id == productId);
  }

  String? getWishlistItemId(String productId) {
    for (WishlistModel item in _wishListItems) {
      if (item.productModel.id == productId) {
        return item.cartId;
      }
    }
    return null;
  }

  Future<bool> addToWishlist(ProductModel productModel) async {
    bool isSuccess = false;

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.addToWishlistUrl,
      body: {'product': productModel.id},
    );

    if (response.isSuccess) {
      String wishlistId = '';
      if (response.body != null && response.body['data'] != null) {
        wishlistId = response.body['data']['_id'] ?? '';
      }
      _wishListItems.add(
        WishlistModel(cartId: wishlistId, productModel: productModel),
      );
      isSuccess = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }

  Future<bool> removeFromWishlist(String id) async {
    bool isSuccess = false;
    String? wishlistId;
    String? productId;

    for (WishlistModel item in _wishListItems) {
      if (item.cartId == id || item.productModel.id == id) {
        wishlistId = item.cartId;
        productId = item.productModel.id;
        break;
      }
    }

    if (wishlistId == null || wishlistId.isEmpty) {
      return false;
    }

    final NetworkResponse response = await getNetworkCaller().deleteRequest(
      Urls.deleteWishlistUrl(wishlistId),
    );

    if (response.isSuccess) {
      _wishListItems.removeWhere(
        (item) => item.cartId == wishlistId || item.productModel.id == productId,
      );
      isSuccess = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }

  Future<bool> toggleWishlist(ProductModel productModel) async {
    if (isProductInWishlist(productModel.id)) {
      return await removeFromWishlist(productModel.id);
    } else {
      return await addToWishlist(productModel);
    }
  }

  Future<bool> getWishlistData() async {
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
