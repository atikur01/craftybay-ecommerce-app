import 'package:crafty_bay/features/shared/data/models/product_model.dart';

class WishlistModel {
  final String cartId;
  final ProductModel productModel;

  WishlistModel({required this.cartId, required this.productModel});

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      cartId: json['_id'],
      productModel: ProductModel.fromJson(json['product']),
    );
  }
}
