import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({super.key, required this.photos});

  final List<String> photos;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220,
            viewportFraction: 1,
            onPageChanged: (index, _) {
              _selectedIndex.value = index;
            },
          ),
          items: widget.photos.map((photo) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(60),
                    image: DecorationImage(image: NetworkImage(photo)),
                  ),
                  alignment: .center,
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, index, _) {
              return Row(
                mainAxisAlignment: .center,
                children: [
                  for (int i = 0; i < widget.photos.length; i++)
                    Container(
                      width: 10,
                      height: 10,
                      margin: .only(right: 2),
                      decoration: BoxDecoration(
                        borderRadius: .circular(10),
                        color: i == index ? AppColors.themeColor : Colors.white,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
