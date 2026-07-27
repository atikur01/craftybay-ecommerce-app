import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../brand/presentation/providers/brand_list_provider.dart';
import '../../../shared/presentation/widgets/brand_card.dart';

class HomeBrandSection extends StatelessWidget {
  const HomeBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Consumer<BrandListProvider>(
        builder: (context, brandListProvider, _) {
          if (brandListProvider.isInitialLoading) {
            return const SizedBox(
              height: 110,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (brandListProvider.brandList.isEmpty) {
            return const Center(
              child: Text(
                'No brands available',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: brandListProvider.brandList.length > 10
                ? 10
                : brandListProvider.brandList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return BrandCard(
                brandModel: brandListProvider.brandList[index],
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          );
        },
      ),
    );
  }
}
