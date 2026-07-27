class OrderModel {
  final String id;
  final String status;
  final String paymentMethod;
  final int totalAmount;
  final String createdAt;
  final Map<String, dynamic>? shippingAddress;

  OrderModel({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.totalAmount,
    required this.createdAt,
    this.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> jsonData) {
    return OrderModel(
      id: jsonData['_id'] ?? '',
      status: jsonData['status'] ?? 'pending',
      paymentMethod: jsonData['payment_method'] ?? 'cod',
      totalAmount: (jsonData['total_amount'] ?? jsonData['amount'] ?? 0) is int
          ? (jsonData['total_amount'] ?? jsonData['amount'] ?? 0)
          : int.tryParse((jsonData['total_amount'] ?? jsonData['amount'] ?? 0).toString()) ?? 0,
      createdAt: jsonData['createdAt'] ?? '',
      shippingAddress: jsonData['shipping_address'] is Map<String, dynamic>
          ? jsonData['shipping_address']
          : null,
    );
  }
}
