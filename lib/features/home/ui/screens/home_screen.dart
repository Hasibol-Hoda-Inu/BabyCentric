import 'package:BabyCentric/features/common/data/models/category_pagination_model/category_pagination_model.dart';
import 'package:BabyCentric/features/common/data/models/product_pagination_model/product_pagination_model.dart';
import 'package:BabyCentric/features/common/ui/controllers/category_list_controller.dart';
import 'package:BabyCentric/features/common/ui/controllers/main_bottom_nav_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/slider_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/new_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/special_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/widgets/category_list_shimmer_loading.dart';
import 'package:BabyCentric/features/common/ui/widgets/product_list_shimmer_loading.dart';
import 'package:BabyCentric/features/product/ui/screens/product_list_by_remarks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../application/assets_path.dart';
import '../../../common/ui/widgets/category_icon_widget.dart';
import '../controller/popular_product_list_controller.dart';
import '../widgets/banner_shimmer_loading.dart';
import '../widgets/home_carousel_slider_widget.dart';
import '../widgets/home_section_title.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/search_box_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController sbController = TextEditingController();
  final ProductListByPopularController _popularPLController = Get.find<ProductListByPopularController>();
  final ProductListBySpecialController _specialPLController =
      Get.find<ProductListBySpecialController>();
  final ProductListByNewController _newPLController =
      Get.find<ProductListByNewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<SliderListController>().getBannerSliders();
          Get.find<CategoryListController>().getCategoryList();
          Get.find<ProductListByPopularController>().getPopularProductList();
          Get.find<ProductListBySpecialController>().getSpecialProductList();
          Get.find<ProductListByNewController>().getNewProductList();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchBoxWidget(controller: sbController),
                const SizedBox(height: 16),
                GetBuilder<SliderListController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return const BannerShimmerLoading();
                    }
                    return HomeCarouselSliderWidget(
                      sliderList: controller.sliderList,
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeSectionHeader(
                  title: 'Category',
                  onTap: () {
                    Get.find<MainBottomNavController>().changeIndex(1);
                  },
                ),
                const SizedBox(height: 8),
                GetBuilder<CategoryListController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return const CategoryListShimmerLoading();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children: _getCategoryList(controller.categoryList),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeSectionHeader(
                  title: 'Popular',
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProductListByRemarksScreen.name,
                    arguments: {
                      "productListByRemark": _popularPLController.productList,
                      "remark": "Popular",
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<ProductListByPopularController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return const ProductListShimmerLoading();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children: _getProductCardList(controller.productList),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeSectionHeader(
                  title: 'Special',
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProductListByRemarksScreen.name,
                    arguments: {
                      "productListByRemark": _specialPLController.productList,
                      "remark": "Special",
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<ProductListBySpecialController>(
                  builder: (controller) {
                    if (controller.initialInProgress) {
                      return const ProductListShimmerLoading();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children: _getProductCardList(controller.productList),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeSectionHeader(
                  title: 'New',
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProductListByRemarksScreen.name,
                    arguments: {
                      "productListByRemark": _newPLController.productList,
                      "remark": "New",
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<ProductListByNewController>(
                  builder: (controller) {
                    if (controller.initialInProgress) {
                      return const ProductListShimmerLoading();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children: _getProductCardList(controller.productList),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getCategoryList(List<CategoryItemModel> categoryModel) {
    List<Widget> categoryList = [];
    for (int i = 0; i < categoryModel.length; i++) {
      categoryList.add(CategoryIconWidget(categoryModel: categoryModel[i]));
    }
    return categoryList;
  }

  List<Widget> _getProductCardList(List<ProductItemModel> productList) {
    List<Widget> productCardList = [];
    for (int i = 0; i < productList.length; i++) {
      productCardList.add(ProductCardWidget(productModel: productList[i]));
    }
    return productCardList;
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset(AssetsPath.navLogo, height: 34),
      actions: [
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.person_outline),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.call_outlined),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}
