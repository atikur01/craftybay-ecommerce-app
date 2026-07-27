import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/asset_paths.dart';
import '../../../../app/constants.dart';
import '../../../shared/presentation/widgets/inc_dec_button.dart';
import '../../../shared/presentation/widgets/snack_bar_message.dart';
import '../../data/models/cart_model.dart';
import '../providers/cart_list_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemModel});

  final CartItemModel cartItemModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: .symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              cartItemModel.product.photos.isNotEmpty
                  ? cartItemModel.product.photos.first
                  : '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Image.asset(
                AssetPaths.dummyPng,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              cartItemModel.product.title,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Color: ${cartItemModel.color ?? ''}   Size: ${cartItemModel.size ?? ''}',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final cartListProvider =
                              context.read<CartListProvider>();
                          final bool isSuccess = await cartListProvider
                              .deleteCartItem(cartItemModel.id);
                          if (context.mounted) {
                            if (isSuccess) {
                              showSnackBarMessage(
                                context,
                                'Item removed from cart',
                              );
                            } else {
                              showSnackBarMessage(
                                context,
                                cartListProvider.errorMessage ??
                                    'Failed to delete item',
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '${Constants.takaSign}${cartItemModel.product.price}',
                        style: TextStyle(
                          fontWeight: .w600,
                          fontSize: 18,
                          color: AppColors.themeColor,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: IncDecButton(
                          maxCount: cartItemModel.product.quantity,
                          minCount: 1,
                          initialValue: cartItemModel.quantity,
                          onChange: (int value) {
                            context
                                .read<CartListProvider>()
                                .updateCartItemQuantity(
                                  cartItemModel.id,
                                  value,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
