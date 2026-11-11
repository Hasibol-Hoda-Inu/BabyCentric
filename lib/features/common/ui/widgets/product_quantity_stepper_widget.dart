import 'package:BabyCentric/application/app_colors.dart';
import 'package:BabyCentric/features/cart/ui/controllers/cart_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductQuantityStepperWidget extends StatefulWidget {
  const ProductQuantityStepperWidget({super.key, required this.onChange});
  final Function(int) onChange;

  @override
  State<ProductQuantityStepperWidget> createState() =>
      _ProductQuantityStepperWidgetState();
}

class _ProductQuantityStepperWidgetState
    extends State<ProductQuantityStepperWidget> {
  CartListController controller = Get.find<CartListController>();
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        IconButton.filledTonal(
          onPressed: _decrement,
          style: IconButton.styleFrom(backgroundColor: AppColors.themeColor),
          icon: const Icon(Icons.remove, color: Colors.white),
        ),
        Text(
          "$_count",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        IconButton.filledTonal(
          onPressed: _increment,
          style: IconButton.styleFrom(backgroundColor: AppColors.themeColor),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  void _increment() {
    _count++;
    widget.onChange(_count);
    setState(() {});
  }

  void _decrement() {
    if (_count > 1) {
      _count--;
      widget.onChange(_count);
      setState(() {});
    }
  }
}
