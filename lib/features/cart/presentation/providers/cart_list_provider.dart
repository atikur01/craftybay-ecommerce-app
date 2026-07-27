import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/cart_model.dart';

class CartListProvider extends ChangeNotifier {
  List<CartItemModel> _cartList = [];

  List<CartItemModel> get cartList => _cartList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> getCartList() async {
    bool isSuccess = false;
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.cartListUrl,
    );
    if (response.isSuccess) {
      _cartList = response.body['data']['results']
          .map<CartItemModel>((item) => CartItemModel.fromJson(item))
          .toList();

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  int get totalPrice {
    int total = 0;
    for (CartItemModel item in _cartList) {
      total += item.product.price * item.quantity;
    }

    return total;
  }

  Future<bool> updateCartItemQuantity(String cartItemId, int quantity) async {
    for (CartItemModel item in _cartList) {
      if (item.id == cartItemId) {
        item.quantity = quantity;
        break;
      }
    }
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().patchRequest(
      Urls.updateCartUrl(cartItemId),
      body: {'quantity': quantity},
    );

    return response.isSuccess;
  }

  Future<bool> deleteCartItem(String cartItemId) async {
    final int index = _cartList.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return false;

    final CartItemModel item = _cartList[index];
    _cartList.removeAt(index);
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().deleteRequest(
      Urls.deleteCartUrl(cartItemId),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      return true;
    } else {
      _cartList.insert(index, item);
      _errorMessage = response.errorMessage;
      notifyListeners();
      return false;
    }
  }
}
