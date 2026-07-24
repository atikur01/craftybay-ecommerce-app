class AddToCartParams {
  final String productId;
  final int quantity;
  final String? color;
  final String? size;

  AddToCartParams({
    required this.productId,
    required this.quantity,
    this.color,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "product": productId,
      "quantity": quantity,
    };
    if (color != null) {
      json['color'] = color!;
    }
    if (size != null) {
      json['size'] = size!;
    }
    return json;
  }
}
