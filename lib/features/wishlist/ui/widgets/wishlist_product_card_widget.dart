import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/product/ui/screens/product_details_screen.dart';
import 'package:BabyCentric/features/wishlist/ui/controllers/delete_wishlist_item_controller.dart';
import 'package:BabyCentric/features/wishlist/ui/controllers/wishlist_item_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../application/app_colors.dart';
import '../../../auth/ui/screens/sign_up_screen.dart';
import '../../../common/ui/widgets/show_snackbar_message.dart';
import '../../data/models/wishlist_item_list_data_model.dart';

class WishlistProductCardWidget extends StatefulWidget {
  const WishlistProductCardWidget({super.key, required this.wishlistItem});

  final WishlistItemModel wishlistItem;

  @override
  State<WishlistProductCardWidget> createState() =>
      _WishlistProductCardWidgetState();
}

class _WishlistProductCardWidgetState extends State<WishlistProductCardWidget> {
  final AuthController _auth = Get.find<AuthController>();
  final WishlistItemListController _wishlistILController =
      Get.find<WishlistItemListController>();
  final DeleteWishlistItemController _deleteWishlistController =
      Get.find<DeleteWishlistItemController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsScreen.name,
          arguments: {"productList": widget.wishlistItem},
        );
      },
      child: SizedBox(
        width: 180,
        child: Card(
          elevation: 5,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.themeColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Image.network(
                  (widget.wishlistItem.product?.photos?.isNotEmpty ?? false)
                      ? widget.wishlistItem.product!.photos!.first
                      : "https://fastly.picsum.photos/id/21/3008/2008.jpg?hmac=T8DSVNvP-QldCew7WD4jj_S3mWwxZPqdF0CNPksSko4",
                  fit: BoxFit.cover,
                  width: 180,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.wishlistItem.product?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${widget.wishlistItem.product?.currentPrice ?? ""}",
                          style: const TextStyle(
                            color: AppColors.themeColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Wrap(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 22,
                            ),
                            Text(
                              "${widget.wishlistItem.product?.quantity ?? ""}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: _deleteWishlistItem,
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: AppColors.themeColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteWishlistItem() async {
    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      String productId = widget.wishlistItem.sId ?? "";
      String token = _auth.accessToken ?? "";
      bool result = await _deleteWishlistController.deleteWishlistItem(
        token,
        productId,
      );
      if (result && mounted) {
        _wishlistILController.getWishlistItemList(token);
        showSnackBarMessage(context, "Cart item removed successfully");
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _deleteWishlistController.errorMessage ?? "Something went wrong",
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
