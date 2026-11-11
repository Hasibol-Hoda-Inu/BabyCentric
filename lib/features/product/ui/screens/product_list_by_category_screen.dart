import 'package:BabyCentric/features/common/ui/controllers/product_list_by_category_controller.dart';
import 'package:BabyCentric/features/common/ui/widgets/product_list_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/ui/widgets/product_card_widget.dart';

class ProductListByCategoryScreen extends StatefulWidget {
  static const String name = "/product/product-list-by-category";
  const ProductListByCategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  final String categoryName;
  final int categoryId;

  @override
  State<ProductListByCategoryScreen> createState() =>
      _ProductListByCategoryScreenState();
}

class _ProductListByCategoryScreenState
    extends State<ProductListByCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ProductListByCategoryController>().getProductListByCategoryId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        leading: IconButton(
          onPressed: _onPop,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(height: 2, color: Colors.grey.shade200),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
        child: GetBuilder<ProductListByCategoryController>(
          builder: (controller) {
            if (controller.inProgress) {
              return ListView.separated(
                itemCount: 6,
                itemBuilder: (context, index) =>
                    const ProductListShimmerLoading(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
              ),
              itemBuilder: (BuildContext context, index) => FittedBox(
                child: ProductCardWidget(
                  productModel: controller.productList[index],
                ),
              ),
              itemCount: controller.productList.length,
            );
          },
        ),
      ),
    );
  }

  void _onPop() {
    Navigator.pop(context);
  }
}
