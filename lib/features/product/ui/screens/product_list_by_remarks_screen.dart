import 'package:BabyCentric/features/common/data/models/product_pagination_model/product_pagination_model.dart';
import 'package:BabyCentric/features/home/ui/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';

class ProductListByRemarksScreen extends StatefulWidget {
  static const String name = "/product/product-list-by-remarks";
  const ProductListByRemarksScreen({
    super.key,
    required this.productList,
    required this.remark,
  });
  final List<ProductItemModel> productList;
  final String remark;
  @override
  State<ProductListByRemarksScreen> createState() =>
      _ProductListByRemarksScreenState();
}

class _ProductListByRemarksScreenState
    extends State<ProductListByRemarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.remark),
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 18,
          ),
          itemBuilder: (BuildContext context, index) => FittedBox(
            child: ProductCardWidget(productModel: widget.productList[index]),
          ),
          itemCount: widget.productList.length,
        ),
      ),
    );
  }

  void _onPop() {
    Navigator.pop(context);
  }
}
