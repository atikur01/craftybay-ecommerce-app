import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../brand/data/models/brand_model.dart';
import '../../../products/presentation/screens/product_list_by_category_screen.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.brandModel});

  final BrandModel brandModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductListByCategoryScreen.name,
          arguments: {
            'brandId': brandModel.id,
            'categoryName': brandModel.title,
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.themeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              brandModel.icon,
              width: 48,
              height: 48,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.branding_watermark_outlined,
                  size: 48,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            brandModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
