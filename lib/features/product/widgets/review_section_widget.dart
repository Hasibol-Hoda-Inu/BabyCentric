import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/common/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:BabyCentric/features/review/ui/screens/review_list_screen.dart';
import 'package:BabyCentric/features/product/ui/controller/add_to_wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../application/app_colors.dart';
import '../../auth/ui/screens/sign_up_screen.dart';
import '../../common/ui/widgets/show_snackbar_message.dart';

class ReviewSectionWidget extends StatefulWidget {
  const ReviewSectionWidget({super.key, required this.productId});
  final String productId;

  @override
  State<ReviewSectionWidget> createState() => _ReviewSectionWidgetState();
}

class _ReviewSectionWidgetState extends State<ReviewSectionWidget> {
  final AddToWishlistController _wishlistController =
      Get.find<AddToWishlistController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        const Row(
          spacing: 4,
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
            Text("4.8", style: TextStyle(fontSize: 18)),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              ReviewListScreen.name,
              arguments: widget.productId,
            );
          },
          child: const Text("Reviews"),
        ),
        GestureDetector(
          onTap: _addToWishList,
          child: GetBuilder<AddToWishlistController>(
            builder: (controller) {
              if (controller.inProgress) {
                return const CenteredCircularProgressIndicator();
              }
              return Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.themeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 14,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addToWishList() async {
    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      bool result = await _wishlistController.postAddToWishlist(
        _auth.accessToken!,
        widget.productId,
      );
      if (result && mounted) {
        showSnackBarMessage(context, "Successfully Added!");
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _wishlistController.errorMessage ??
                "Something went wrong, Please try again",
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
}
