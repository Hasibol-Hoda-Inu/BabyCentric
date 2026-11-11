import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/ui/screens/otp_verification_screen.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/auth/ui/screens/splash_screen.dart';
import '../features/cart/ui/screens/cart_screen.dart';
import '../features/category/ui/screens/category_list_screen.dart';
import '../features/checkout/ui/screens/checkout_screen.dart';
import '../features/checkout/ui/screens/thank_you_screen.dart';
import '../features/common/ui/screens/main_bottom_nav_screen.dart';
import '../features/product/ui/screens/product_details_screen.dart';
import '../features/product/ui/screens/product_list_by_category_screen.dart';
import '../features/product/ui/screens/product_list_by_remarks_screen.dart';
import '../features/review/ui/screens/create_review.dart';
import '../features/review/ui/screens/review_list_screen.dart';
import 'app_theme_data.dart';
import 'controller_binders.dart';

class BabyCentric extends StatelessWidget {
  const BabyCentric({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightThemeData,
      darkTheme: AppThemeData.darkThemeData,
      themeMode: ThemeMode.light,
      initialBinding: ControllerBinder(),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;
        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();
        } else if (settings.name == SignInScreen.name) {
          widget = const SignInScreen();
        } else if (settings.name == OtpVerificationScreen.name) {
          Map<String, dynamic> loginInfo =
              settings.arguments as Map<String, dynamic>;
          widget = OtpVerificationScreen(
            email: loginInfo["email"],
            password: loginInfo["password"],
          );
        } else if (settings.name == SignUpScreen.name) {
          widget = const SignUpScreen();
        } else if (settings.name == MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();
        } else if (settings.name == CategoryListScreen.name) {
          widget = const CategoryListScreen();
        } else if (settings.name == ProductListByCategoryScreen.name) {
          Map<String, dynamic> name =
              settings.arguments as Map<String, dynamic>;
          widget = ProductListByCategoryScreen(
            categoryName: name['categoryName'],
            categoryId: name["categoryId"],
          );
        } else if (settings.name == ProductListByRemarksScreen.name) {
          Map<String, dynamic> productListByRemarks =
              settings.arguments as Map<String, dynamic>;
          widget = ProductListByRemarksScreen(
            productList: productListByRemarks["productListByRemark"],
            remark: productListByRemarks["remark"],
          );
        } else if (settings.name == ProductDetailsScreen.name) {
          Map<String, dynamic> productList =
              settings.arguments as Map<String, dynamic>;
          widget = ProductDetailsScreen(
            productList: productList["productList"],
          );
        } else if (settings.name == ReviewListScreen.name) {
          String id = settings.arguments as String;
          widget = ReviewListScreen(productId: id);
        } else if (settings.name == CreateReview.name) {
          widget = const CreateReview();
        } else if (settings.name == CartScreen.name) {
          widget = const CartScreen();
        } else if (settings.name == CheckoutScreen.name) {
          widget = const CheckoutScreen();
        } else if (settings.name == ThankYouScreen.name) {
          widget = const ThankYouScreen();
        }

        return MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        );
      },
    );
  }
}
