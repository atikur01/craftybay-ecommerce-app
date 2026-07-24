import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/snack_bar_message.dart';
import 'package:crafty_bay/features/wishlist/presentation/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/providers/main_nav_holder_provider.dart';
import '../../../shared/presentation/widgets/centered_progress_indicator.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  static const String name = '/wishlist';

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishListProvider>().getWishlistData();
    });
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    final wishListProvider = context.read<WishListProvider>();
    if ((wishListProvider.isLoading == false) &&
        _scrollController.position.extentAfter < 300) {
      wishListProvider.getWishlistData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _backToHome(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wishlist'),
          leading: IconButton(
            onPressed: _backToHome,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Consumer<WishListProvider>(
          builder: (context, wishListProvider, _) {
            if (wishListProvider.isInitialLoading) {
              return const CenteredProcessIndicator();
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: wishListProvider.productList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 4,
                        ),
                    itemBuilder: (context, index) {
                      final item = wishListProvider.productList[index];
                      return FittedBox(
                        child: Stack(
                          children: [
                            ProductCard(
                              productModel: item.productModel,
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: GestureDetector(
                                onTap: () {
                                  _onTapRemoveItem(item.cartId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.themeColor.withAlpha(60),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (wishListProvider.isLoadingMore)
                  const LinearProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onTapRemoveItem(String id) async {
    final wishListProvider = context.read<WishListProvider>();
    final isSuccess = await wishListProvider.removeFromWishlist(id);
    if (mounted) {
      if (isSuccess) {
        showSnackBarMessage(context, 'Removed from wishlist');
      } else if (wishListProvider.errorMessage != null) {
        showSnackBarMessage(context, wishListProvider.errorMessage!);
      }
    }
  }

  void _backToHome() {
    context.read<MainNavHolderProvider>().backToHome();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
