import 'package:carousel_slider/carousel_slider.dart';
import 'package:BabyCentric/application/app_colors.dart';
import 'package:BabyCentric/features/home/data/models/slider_model.dart';
import 'package:flutter/material.dart';

class HomeCarouselSliderWidget extends StatefulWidget {
  const HomeCarouselSliderWidget({super.key, required this.sliderList});
  final List<SliderModel> sliderList;
  @override
  State<HomeCarouselSliderWidget> createState() =>
      _HomeCarouselSliderWidgetState();
}

class _HomeCarouselSliderWidgetState extends State<HomeCarouselSliderWidget> {
  final ValueNotifier<int> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            viewportFraction: 1,
            onPageChanged: (currentIndex, reason) {
              _valueNotifier.value = currentIndex;
            },
          ),
          items: widget.sliderList.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(banner.photoUrl ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(banner.description ?? "",
                        //   style: const TextStyle(
                        //   fontSize: 22,
                        //   fontWeight: FontWeight.w700,
                        //     color: Colors.white
                        // ),),
                        // SizedBox(
                        //   width: 120,
                        //   child: ElevatedButton(
                        //       onPressed: (){},
                        //       child: const Text("Buy Now")),
                        // )
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                for (int i = 0; i < widget.sliderList.length; i++)
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: value == i
                        ? AppColors.themeColor
                        : Colors.grey.shade300,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
