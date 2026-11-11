import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../../../services/network_caller/network_caller.dart';

class SignUpController extends GetxController{
  bool _inProgress = false;
  bool get inProgress=>_inProgress;

  String? _errorMessage;
  String? get errorMessage =>_errorMessage;

  Future<bool> signUp(
      String firstName,
      String lastName,
      String email,
      String password,
      dynamic phone,
      String city,
      // dynamic customerAddress,
      // String customerState,
      // String customerPostCode,
      // String customerCountry,
      // dynamic customerFax,
      // String shippingName,
      // dynamic shippingAddress,
      // String shippingCity,
      // String shippingState,
      // String shippingPostCode,
      // String shippingCountry,
      // dynamic shippingNumber,
      ) async{
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "city": city
    };

    final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
        Urls.signUpUrl,
        body: body,
    );

    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;
    }else{
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}