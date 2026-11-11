import 'package:BabyCentric/application/app_colors.dart';
import 'package:BabyCentric/features/auth/ui/screens/sign_up_screen.dart';
import 'package:BabyCentric/features/cart/ui/widgets/cart_item_card_widget.dart';
import 'package:BabyCentric/features/checkout/ui/screens/checkout_screen.dart';
import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:BabyCentric/features/common/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:BabyCentric/features/common/ui/widgets/show_snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/controllers/main_bottom_nav_controller.dart';
import '../controllers/cart_list_controller.dart';
import '../widgets/cart_screen_shimmer_loading.dart';

class CartScreen extends StatefulWidget {
  static const String name = "/cartScreen";
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final AuthController _auth = Get.find<AuthController>();
  final CartListController _cartListController = Get.find<CartListController>();

  @override
  void initState() {
    super.initState();
    getCartItemList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _onPop(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _onPop,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Cart"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(height: 2, color: Colors.grey.shade200),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getCartItemList();
          },
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<CartListController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return const CartScreenShimmerLoading();
                    }
                    return ListView.builder(
                      itemCount: controller.cartItemList.length,
                      itemBuilder: (BuildContext context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CartItemCardWidget(
                          cartItem: controller.cartItemList[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              buildCheckOutContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckOutContainer(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.themeColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Total Price"),
              GetBuilder<CartListController>(
                builder: (controller) {
                  if (controller.inProgress) {
                    return const CenteredCircularProgressIndicator();
                  }
                  return Text(
                    "\$${controller.totalPrice}",
                    style: const TextStyle(
                      color: AppColors.themeColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CheckoutScreen.name);
              },
              child: const Text(
                "Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPop() {
    Get.find<MainBottomNavController>().backToHome();
    Get.offNamed(MainBottomNavScreen.name);
  }

  Future<void> getCartItemList() async {
    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      String? token = _auth.accessToken;
      bool result = await _cartListController.getCartList(token ?? "");
      if (result && mounted) {
        _cartListController.calculateTotalPrice();
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _cartListController.errorMessage ?? "Something went wrong",
            false,
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushNamed(context, SignUpScreen.name);
      }
    }
  }
}
