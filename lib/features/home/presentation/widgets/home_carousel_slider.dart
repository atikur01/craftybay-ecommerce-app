import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../data/models/slider_model.dart';

class HomeCarouselSlider extends StatefulWidget {
  const HomeCarouselSlider({super.key, required this.sliders});

  final List<SliderModel> sliders;

  @override
  State<HomeCarouselSlider> createState() => _HomeCarouselSliderState();
}

class _HomeCarouselSliderState extends State<HomeCarouselSlider> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            viewportFraction: 1,
            onPageChanged: (index, _) {
              _selectedIndex.value = index;
            },
          ),
          items: widget.sliders.map((slider) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius: .circular(8),
                    image: DecorationImage(
                      image: NetworkImage(slider.photoUrl),
                      onError: (_, _) => Icon(Icons.error_outline),
                      fit: .cover,
                    ),
                  ),
                  alignment: .center,
                );
              },
            );
          }).toList(),
        ),
        ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, index, _) {
            return Row(
              mainAxisAlignment: .center,
              children: [
                for (int i = 0; i < widget.sliders.length; i++)
                  Container(
                    width: 10,
                    height: 10,
                    margin: .only(right: 2),
                    decoration: BoxDecoration(
                      borderRadius: .circular(10),
                      color: i == index
                          ? AppColors.themeColor
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
