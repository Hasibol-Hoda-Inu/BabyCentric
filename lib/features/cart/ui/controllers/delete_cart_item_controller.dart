import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';

class DeleteCartItemController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _currentDeletingId;
  bool isDeleting(String cartItemId) => _currentDeletingId == cartItemId;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deleteCartItem(String token, String productId) async {
    bool isSuccess = false;
    _currentDeletingId = productId;
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>()
        .deleteRequest(Urls.deleteCartItemUrl(productId), accessToken: token);
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    _currentDeletingId = null;
    update();
    return isSuccess;
  }
}
