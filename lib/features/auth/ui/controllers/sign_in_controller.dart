import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../../../services/network_caller/network_caller.dart';
import '../../../common/ui/controllers/auth_controller.dart';
import '../../data/models/sign_in_model.dart';

class SignInController extends GetxController{
  bool _inProgress = false;
  bool get inProgress=>_inProgress;

  String? _errorMessage;
  String? get errorMessage =>_errorMessage;

  Future<bool> signIn(String userEmail, String userPassword) async{
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> body = {
    "email": userEmail,
    "password": userPassword,
    };

    final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
        Urls.signInUrl,
        body: body,
    );
    if(response.isSuccess){
      AuthSuccessModel signInModel = AuthSuccessModel.fromJson(response.responseData);
      await Get.find<AuthController>().saveUserData(
        signInModel.data!.token!,
        signInModel.data!.user!,
      );
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