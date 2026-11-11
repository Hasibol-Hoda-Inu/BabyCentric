import 'package:BabyCentric/features/cart/ui/screens/cart_screen.dart';
import 'package:BabyCentric/features/common/ui/controllers/category_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/slider_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/new_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/popular_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/special_product_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/ui/screens/sign_up_screen.dart';
import '../../../category/ui/screens/category_list_screen.dart';
import '../../../home/ui/screens/home_screen.dart';
import '../../../wishlist/ui/screens/wishlist_screen.dart';
import '../controllers/auth_controller.dart';
import '../controllers/main_bottom_nav_controller.dart';

class MainBottomNavScreen extends StatefulWidget {
  static const String name = "/MainBottomNavScreen";
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryListScreen(),
    CartScreen(),
    WishlistScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Get.find<SliderListController>().getBannerSliders();
    Get.find<CategoryListController>().getCategoryList();
    Get.find<ProductListByPopularController>().getPopularProductList();
    Get.find<ProductListBySpecialController>().getSpecialProductList();
    Get.find<ProductListByNewController>().getNewProductList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: _screens[controller.selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (index) async {
              if (index == 2 || index == 3) {
                final bool isLoggedIn =
                await Get.find<AuthController>().isUserLoggedIn();

                if (!mounted) return;

                if (!isLoggedIn) {
                  controller.backToHome();
                  Navigator.pushNamed(context, SignUpScreen.name);
                  return;
                }
              }
              controller.changeIndex(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined),
                label: "Categories",
              ),
              NavigationDestination(
                icon: Icon(Icons.add_shopping_cart),
                label: "Cart",
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                label: "Wishlist",
              ),
            ],
          ),
        );
      },
    );
  }
}
