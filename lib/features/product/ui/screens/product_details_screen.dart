import 'package:BabyCentric/application/app_colors.dart';
import 'package:BabyCentric/features/auth/ui/screens/sign_up_screen.dart';
import 'package:BabyCentric/features/common/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:BabyCentric/features/product/ui/controller/add_to_cart_controller.dart';
import 'package:BabyCentric/features/product/widgets/product_image_carousel_slider_widget.dart';
import 'package:BabyCentric/features/common/ui/widgets/product_quantity_stepper_widget.dart';
import 'package:BabyCentric/features/product/widgets/size_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/ui/screens/cart_screen.dart';
import '../../../common/data/models/product_pagination_model/product_pagination_model.dart';
import '../../../common/ui/controllers/auth_controller.dart';
import '../../../common/ui/widgets/show_snackbar_message.dart';
import '../../widgets/color_picker_widget.dart';
import '../../widgets/review_section_widget.dart';
import '../controller/product_id_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String name = "/product/product-details";
  const ProductDetailsScreen({super.key, required this.productList});
  final ProductItemModel productList;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final List<Color> _colors = [
    Colors.black87,
    Colors.blueAccent,
    Colors.blueGrey,
    Colors.green,
    Colors.orange,
  ];
  final List<String> _sizes = ["S", "M", "L", "XL", "XXL"];

  final AddToCartController _addToCart = Get.find<AddToCartController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        leading: IconButton(
          onPressed: _onPop,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(height: 2, color: Colors.grey.shade200),
        ),
      ),
      body: Column(
        children: [
          ProductImageCarouselSliderWidget(
            imageUrls: widget.productList.photos ?? [],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: 0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productList.title ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: AppColors.themeColor,
                                ),
                              ),
                              ReviewSectionWidget(
                                productId: widget.productList.sId.toString(),
                              ),
                            ],
                          ),
                        ),
                        ProductQuantityStepperWidget(onChange: (int value) {}),
                      ],
                    ),
                    Text(
                      "Color",
                      style: TextTheme.of(context).titleMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    ColorPickerWidget(colors: _colors),
                    const SizedBox(height: 16),
                    Text(
                      "Size",
                      style: TextTheme.of(context).titleMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    SizePickerWidget(sizes: _sizes),
                    const SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextTheme.of(context).titleMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.productList.description ?? "",
                      style: TextTheme.of(context).bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildAddToCartContainer(
            context,
            widget.productList.currentPrice.toString(),
          ),
        ],
      ),
    );
  }

  Widget buildAddToCartContainer(BuildContext context, String price) {
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
              Text("Price", style: TextTheme.of(context).titleMedium),
              Text(
                "\$$price",
                style: const TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 120,
            child: GetBuilder<AddToCartController>(
              builder: (controller) {
                if (controller.inProgress) {
                  return const CenteredCircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    _addToCartMethod();
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCartMethod() async {
    String productId = widget.productList.sId.toString(); // Your product ID
    Get.find<ProductIdController>().setProductId(productId);

    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      String token = _auth.accessToken!;
      debugPrint("TOKEN: $token");
      final bool result = await _addToCart.postAddToCart(
        widget.productList.sId.toString(),
        token,
      );
      if (result && mounted) {
        _onTapCartScreen();
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _addToCart.errorMessage ?? "Something went wrong, Please try again",
            false,
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          SignUpScreen.name,
          (predicate) => false,
        );
      }
    }
  }

  void _onTapCartScreen() {
    Navigator.pushNamed(context, CartScreen.name);
    // Get.find<MainBottomNavController>().changeIndex(2);
  }

  void _onPop() {
    Navigator.pop(context);
  }
}
