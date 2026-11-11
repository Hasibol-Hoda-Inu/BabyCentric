import 'package:BabyCentric/features/auth/ui/controllers/otp_verification_controller.dart';
import 'package:BabyCentric/features/auth/ui/controllers/read_profile_controller.dart';
import 'package:BabyCentric/features/auth/ui/controllers/timer_controller.dart';
import 'package:BabyCentric/features/auth/ui/controllers/sign_in_controller.dart';
import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/common/ui/controllers/category_list_controller.dart';
import 'package:BabyCentric/features/common/ui/controllers/main_bottom_nav_controller.dart';
import 'package:BabyCentric/features/common/ui/controllers/product_list_by_category_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/new_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/popular_product_list_controller.dart';
import 'package:BabyCentric/features/home/ui/controller/special_product_list_controller.dart';
import 'package:BabyCentric/features/product/ui/controller/product_details_controller.dart';
import 'package:BabyCentric/features/review/ui/controller/review_list_controller.dart';
import 'package:get/get.dart';

import '../features/auth/ui/controllers/sign_up_controller.dart';
import '../features/cart/ui/controllers/cart_list_controller.dart';
import '../features/cart/ui/controllers/delete_cart_item_controller.dart';
import '../features/checkout/serivices/stripe_payment_gateway/stripe_payment_gateway.dart';
import '../features/checkout/ui/controllers/create_order_controller.dart';
import '../features/home/ui/controller/slider_list_controller.dart';
import '../features/product/ui/controller/add_to_cart_controller.dart';
import '../features/product/ui/controller/product_id_controller.dart';
import '../features/product/ui/controller/add_to_wishlist_controller.dart';
import '../features/wishlist/ui/controllers/delete_wishlist_item_controller.dart';
import '../features/wishlist/ui/controllers/wishlist_item_list_controller.dart';
import '../services/network_caller/network_caller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkCaller());
    Get.put(MainBottomNavController());
    Get.put(TimerController());
    Get.put(SignInController());
    Get.put(OtpVerificationController());
    Get.put(ReadProfileController());
    Get.put(AuthController());
    Get.put(SignUpController());
    Get.put(SliderListController());
    Get.put(CategoryListController());
    Get.put(ProductListByNewController());
    Get.put(ProductListBySpecialController());
    Get.put(ProductListByPopularController());
    Get.put(ProductListByCategoryController());
    Get.put(ProductDetailsController());
    Get.put(ReviewListController());
    Get.put(AddToCartController());
    Get.put(ProductIdController());
    Get.put(CartListController());
    Get.put(AddToWishlistController());
    Get.put(WishlistItemListController());
    Get.put(CreateOrderController());
    Get.put(DeleteCartItemController());
    Get.put(DeleteWishlistItemController());
    Get.put(StripePaymentGateway());
  }
}
