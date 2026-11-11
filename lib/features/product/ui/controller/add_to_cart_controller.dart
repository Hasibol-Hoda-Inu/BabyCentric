import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';

class AddToCartController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> postAddToCart(String id, String token) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, String> body = {"product": id};

    final NetworkResponse response = await Get.find<NetworkCaller>()
        .postRequest(Urls.addToCartUrl, body: body, accessToken: token);
    if (response.isSuccess) {
      isSuccess = true;
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
