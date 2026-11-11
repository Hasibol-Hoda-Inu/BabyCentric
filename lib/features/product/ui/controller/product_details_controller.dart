import 'package:BabyCentric/features/product/data/models/product_details_model.dart';
import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';

class ProductDetailsController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductDetailsModel? _productDetailsModel;
  ProductDetails? get productDetails {
    if (_productDetailsModel?.data != null &&
        _productDetailsModel!.data!.isNotEmpty) {
      return _productDetailsModel?.data?.first;
    }
    return null;
  }

  Future<bool> getProductDetails(String id) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.productDetails,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _productDetailsModel = ProductDetailsModel.fromJson(
        response.responseData,
      );
      _errorMessage = null;
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
