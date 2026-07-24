import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/cart/presentation/screens/cart_screen.dart';
import 'package:crafty_bay/features/category/presentation/providers/category_list_provider.dart';
import 'package:crafty_bay/features/category/presentation/screens/category_screen.dart';
import 'package:crafty_bay/features/home/presentation/providers/home_sliders_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/new_product_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/popular_product_provider.dart';
import 'package:crafty_bay/features/home/presentation/providers/special_product_provider.dart';
import 'package:crafty_bay/features/home/presentation/screens/home_screen.dart';
import 'package:crafty_bay/features/wishlist/presentation/providers/wish_list_provider.dart';
import 'package:crafty_bay/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/main_nav_holder_provider.dart';

class MainNavHolderScreen extends StatefulWidget {
  const MainNavHolderScreen({super.key});

  static const String name = '/main-nav-holder';

  @override
  State<MainNavHolderScreen> createState() => _MainNavHolderScreenState();
}

class _MainNavHolderScreenState extends State<MainNavHolderScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    WishlistScreen(),
  ];

  final HomeSlidersProvider _homeSlidersProvider = HomeSlidersProvider();
  final CategoryListProvider _categoryListProvider = CategoryListProvider();
  final PopularProductProvider _popularProductProvider = PopularProductProvider();
  final SpecialProductProvider _specialProductProvider = SpecialProductProvider();
  final NewProductProvider _newProductProvider = NewProductProvider();

  @override
  void initState() {
    super.initState();
    _homeSlidersProvider.getSliders();
    _categoryListProvider.getCategoryData();
    _popularProductProvider.getPopularProducts();
    _specialProductProvider.getSpecialProducts();
    _newProductProvider.getNewProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishListProvider>().getWishlistData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _homeSlidersProvider),
        ChangeNotifierProvider.value(value: _categoryListProvider),
        ChangeNotifierProvider.value(value: _popularProductProvider),
        ChangeNotifierProvider.value(value: _specialProductProvider),
        ChangeNotifierProvider.value(value: _newProductProvider),
      ],
      child: Consumer<MainNavHolderProvider>(
        builder: (context, mainNavHolderProvider, _) {
          return Scaffold(
            body: _screens[mainNavHolderProvider.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: mainNavHolderProvider.currentIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: AppColors.themeColor,
              showUnselectedLabels: true,
              onTap: mainNavHolderProvider.changeIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Category',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket_outlined),
                  label: 'Carts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  label: 'Wishlist',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
