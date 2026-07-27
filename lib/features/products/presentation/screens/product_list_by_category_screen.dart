import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/widgets/centered_progress_indicator.dart';
import '../../../shared/presentation/widgets/product_card.dart';
import '../providers/product_list_provider.dart';

class ProductListByCategoryScreen extends StatefulWidget {
  const ProductListByCategoryScreen({
    super.key,
    this.categoryId,
    this.brandId,
    this.tag,
    this.remark,
    required this.categoryName,
  });

  static const String name = '/products-list-by-category';

  final String? categoryId;
  final String? brandId;
  final String? tag;
  final String? remark;
  final String categoryName;

  @override
  State<ProductListByCategoryScreen> createState() =>
      _ProductListByCategoryScreenState();
}

class _ProductListByCategoryScreenState
    extends State<ProductListByCategoryScreen> {
  final ProductListProvider _productListProvider = ProductListProvider();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productListProvider.getProductData(
      categoryId: widget.categoryId,
      brandId: widget.brandId,
      tag: widget.tag,
      remark: widget.remark,
    );
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if ((_productListProvider.isLoading == false) &&
        _scrollController.position.extentBefore < 300) {
      _productListProvider.getProductData(
        categoryId: widget.categoryId,
        brandId: widget.brandId,
        tag: widget.tag,
        remark: widget.remark,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _productListProvider,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.categoryName)),
        body: Consumer<ProductListProvider>(
          builder: (context, productListProvider, _) {
            if (productListProvider.isInitialLoading) {
              return CenteredProcessIndicator();
            }

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: productListProvider.productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return FittedBox(
                        child: ProductCard(
                          productModel: productListProvider.productList[index],
                        ),
                      );
                    },
                  ),
                ),
                if (productListProvider.isLoadingMore)
                  LinearProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
