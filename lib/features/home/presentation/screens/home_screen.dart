import 'package:crafty_bay/features/home/presentation/providers/home_sliders_provider.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/providers/main_nav_holder_provider.dart';
import '../widgets/home_app_bar.dart';
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
                headerText: 'Category',
                onTapSeeAll: () {
                  context.read<MainNavHolderProvider>().navigateToCategory();
                },
              ),
              HomeCategorySection(),
              SectionHeader(
                headerText: 'Popular',
                onTapSeeAll: () {
                  context.read<MainNavHolderProvider>().navigateToCategory();
                },
              ),
              SingleChildScrollView(
                scrollDirection: .horizontal,
                child: Row(
                  // children: [1, 2, 3, 4, 5].map((e) => ProductCard()).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
