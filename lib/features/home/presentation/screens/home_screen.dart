import 'package:crafty_bay/features/brand/presentation/screens/brand_list_screen.dart';
import 'package:crafty_bay/features/home/presentation/providers/home_sliders_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/new_product_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/popular_product_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/special_product_provider.dart';
import 'package:crafty_bay/features/products/presentation/screens/product_list_by_category_screen.dart';
import 'package:crafty_bay/features/shared/data/models/product_model.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../shared/presentation/providers/main_nav_holder_provider.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_brand_section.dart';
import '../widgets/home_carousel_slider.dart';
import '../widgets/home_category_section.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Padding(
        padding: const .all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              ProductSearchBar(),
              Consumer<HomeSlidersProvider>(
                builder: (context, homeSliderProvider, _) {
                  if (homeSliderProvider.getSlidersInProgress) {
                    return SizedBox(
                      height: 180,
                      child: CenteredProcessIndicator(),
                    );
                  }

                  return HomeCarouselSlider(
                    sliders: homeSliderProvider.sliders,
                  );
                },
              ),
              SectionHeader(
                headerText: 'All Categories',
                onTapSeeAll: () {
                  context.read<MainNavHolderProvider>().navigateToCategory();
                },
              ),
              HomeCategorySection(),
              SectionHeader(
                headerText: 'Popular',
                onTapSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    ProductListByCategoryScreen.name,
                    arguments: {
                      'categoryName': 'Popular Products',
                      'remark': 'popular',
                      'categoryId': AppConstants.popularCategoryId,
                    },
                  );
                },
              ),
              Consumer<PopularProductProvider>(
                builder: (context, popularProductProvider, _) {
                  if (popularProductProvider.getPopularProductsInProgress) {
                    return SizedBox(
                      height: 180,
                      child: CenteredProcessIndicator(),
                    );
                  }

                  return _buildProductHorizontalList(
                    popularProductProvider.productList,
                  );
                },
              ),
              SectionHeader(
                headerText: 'Special',
                onTapSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    ProductListByCategoryScreen.name,
                    arguments: {
                      'categoryName': 'Special Products',
                      'remark': 'special',
                      'categoryId': AppConstants.specialCategoryId,
                    },
                  );
                },
              ),
              Consumer<SpecialProductProvider>(
                builder: (context, specialProductProvider, _) {
                  if (specialProductProvider.getSpecialProductsInProgress) {
                    return SizedBox(
                      height: 180,
                      child: CenteredProcessIndicator(),
                    );
                  }

                  return _buildProductHorizontalList(
                    specialProductProvider.productList,
                  );
                },
              ),
              SectionHeader(
                headerText: 'New',
                onTapSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    ProductListByCategoryScreen.name,
                    arguments: {
                      'categoryName': 'New Products',
                      'remark': 'new',
                      'categoryId': AppConstants.newCategoryId,
                    },
                  );
                },
              ),
              Consumer<NewProductProvider>(
                builder: (context, newProductProvider, _) {
                  if (newProductProvider.getNewProductsInProgress) {
                    return SizedBox(
                      height: 180,
                      child: CenteredProcessIndicator(),
                    );
                  }

                  return _buildProductHorizontalList(
                    newProductProvider.productList,
                  );
                },
              ),
              SectionHeader(
                headerText: 'Brands',
                onTapSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    BrandListScreen.name,
                  );
                },
              ),
              const HomeBrandSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductHorizontalList(List<ProductModel> productList) {
    if (productList.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'No products available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ProductCard(productModel: productList[index]);
        },
      ),
    );
  }
}
