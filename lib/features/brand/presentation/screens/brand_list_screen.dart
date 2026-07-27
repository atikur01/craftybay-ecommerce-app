import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/widgets/brand_card.dart';
import '../../../shared/presentation/widgets/centered_progress_indicator.dart';
import '../providers/brand_list_provider.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  static const String name = '/brand-list-screen';

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    final provider = context.read<BrandListProvider>();
    if (!provider.isLoading &&
        _scrollController.position.extentBefore < 300) {
      provider.getBrandData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Brands')),
      body: Consumer<BrandListProvider>(
        builder: (context, brandListProvider, _) {
          if (brandListProvider.isInitialLoading) {
            return const CenteredProcessIndicator();
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: brandListProvider.brandList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return FittedBox(
                      child: BrandCard(
                        brandModel: brandListProvider.brandList[index],
                      ),
                    );
                  },
                ),
              ),
              if (brandListProvider.isLoadingMore)
                const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
