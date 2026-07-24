import 'package:crafty_bay/features/category/presentation/providers/category_list_provider.dart';
import 'package:crafty_bay/features/shared/presentation/providers/main_nav_holder_provider.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/widgets/category_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  late final CategoryListProvider _categoryListProvider;

  @override
  void initState() {
    super.initState();
    _categoryListProvider = context.read<CategoryListProvider>();

    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if ((_categoryListProvider.isLoading == false) &&
        _scrollController.position.extentBefore < 300) {
      _categoryListProvider.getCategoryData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => _backToHome(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Category'),
          leading: IconButton(
            onPressed: _backToHome,
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: _categoryListProvider,
          child: Consumer<CategoryListProvider>(
            builder: (context, _, _) {
              if (_categoryListProvider.isInitialLoading) {
                return CenteredProcessIndicator();
              }

              return Padding(
                padding: .symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _categoryListProvider.refreshCategoryList();
                        },
                        child: GridView.builder(
                          itemCount: _categoryListProvider.categoryList.length,
                          controller: _scrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return FittedBox(
                              child: CategoryCard(
                                categoryModel:
                                    _categoryListProvider.categoryList[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (_categoryListProvider.isLoadingMore)
                      LinearProgressIndicator(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _backToHome() {
    context.read<MainNavHolderProvider>().backToHome();
  }
}
