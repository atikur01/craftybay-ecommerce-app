import 'package:flutter/foundation.dart';

import '../../../../app/get_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  List<OrderModel> _orderList = [];
  OrderModel? _selectedOrder;

  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  List<OrderModel> get orderList => _orderList;
  OrderModel? get selectedOrder => _selectedOrder;

  Future<bool> getOrderList() async {
    bool isSuccess = false;
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.orderListUrl,
    );

    if (response.isSuccess) {
      List<OrderModel> list = [];
      if (response.body['data'] != null && response.body['data']['results'] != null) {
        for (Map<String, dynamic> jsonData in response.body['data']['results']) {
          list.add(OrderModel.fromJson(jsonData));
        }
      }
      _orderList = list;
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<OrderModel?> getOrderDetails(String orderId) async {
    _isLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.readOrderUrl(orderId),
    );

    if (response.isSuccess && response.body['data'] != null) {
      _selectedOrder = OrderModel.fromJson(response.body['data']);
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isLoading = false;
    notifyListeners();
    return _selectedOrder;
  }

  Future<bool> createOrder({
    required String paymentMethod,
    required Map<String, dynamic> shippingAddress,
    String? redirectUrl,
  }) async {
    _isActionLoading = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
    };
    if (redirectUrl != null) body['redirect_url'] = redirectUrl;

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.createOrderUrl,
      body: body,
    );

    _isActionLoading = false;
    notifyListeners();
    return response.isSuccess;
  }

  Future<bool> cancelOrder(String orderId) async {
    _isActionLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().patchRequest(
      Urls.cancelOrderUrl(orderId),
    );

    if (response.isSuccess) {
      getOrderList();
    } else {
      _errorMessage = response.errorMessage;
    }

    _isActionLoading = false;
    notifyListeners();
    return response.isSuccess;
  }

  Future<bool> processTransaction({
    required String tranId,
    required String status,
    required String amount,
  }) async {
    _isActionLoading = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().postRequest(
      Urls.orderTransactionUrl,
      body: {
        'tran_id': tranId,
        'status': status,
        'amount': amount,
      },
    );

    _isActionLoading = false;
    notifyListeners();
    return response.isSuccess;
  }
}
