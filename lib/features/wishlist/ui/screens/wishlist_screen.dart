import 'package:BabyCentric/features/auth/ui/screens/sign_up_screen.dart';
import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/common/ui/widgets/product_list_shimmer_loading.dart';
import 'package:BabyCentric/features/common/ui/widgets/show_snackbar_message.dart';
import 'package:BabyCentric/features/wishlist/ui/controllers/wishlist_item_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/controllers/main_bottom_nav_controller.dart';
import '../widgets/wishlist_product_card_widget.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistItemListController _wishlistItemController =
      Get.find<WishlistItemListController>();
  final AuthController _auth = Get.find<AuthController>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _getWishlistItemList();
    _scrollController = ScrollController()..addListener(_loadMoreData);
  }

  void _loadMoreData() {
    if (_scrollController.position.extentAfter < 300) {
      _getWishlistItemList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _onTap,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _onTap,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Wishlist"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(height: 2, color: Colors.grey.shade200),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _wishlistItemController.refreshWishlistItemList();
          },
          child: GetBuilder<WishlistItemListController>(
            builder: (controller) {
              if (controller.initialInProgress) {
                return const ProductListShimmerLoading();
              }
              return Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  right: 8,
                  bottom: 0,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                        itemBuilder: (BuildContext context, index) => FittedBox(
                          child: WishlistProductCardWidget(
                            wishlistItem:
                                _wishlistItemController.wishlistItemList[index],
                          ),
                        ),
                        itemCount:
                            _wishlistItemController.wishlistItemList.length,
                      ),
                    ),
                    Visibility(
                      visible: controller.inProgress,
                      child: const LinearProgressIndicator(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getWishlistItemList() async {
    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      String token = _auth.accessToken!;

      bool result = await _wishlistItemController.getWishlistItemList(token);
      if (result && mounted) {
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _wishlistItemController.errorMessage ?? "Something went wrong",
            false,
          );
        }
      }
    } else {
      if (mounted) {
        _onTapSignUp();
      }
    }
  }

  void _onTapSignUp() {
    // Get.offAllNamed(SignUpScreen.name);
    Navigator.pushReplacementNamed(context, SignUpScreen.name);
  }

  void _onTap() {
    Get.find<MainBottomNavController>().backToHome();
  }
}
