import 'package:BabyCentric/features/cart/data/models/cart_item_list_data_model.dart';
import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';

class CartListController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  int totalPrice = 0;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<Results> _cartItemList = [];
  List<Results> get cartItemList => _cartItemList;

  Future<bool> getCartList(String token) async {
    bool isSuccess = false;
    _inProgress = true;
    _cartItemList.clear();
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.cartListUrl,
      accessToken: token,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;

      CartItemListDataModel cartItemListDataModel =
          CartItemListDataModel.fromJson(response.responseData);
      _cartItemList.addAll(cartItemListDataModel.data?.results ?? []);
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  void calculateTotalPrice() {
    totalPrice = _cartItemList.fold<int>(0, (sum, result) {
      final price = result.product?.currentPrice ?? 0;
      final quantity = result.quantity ?? 0;
      return sum + (price * quantity);
    });
  }
}
