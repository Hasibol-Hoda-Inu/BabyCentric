import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../application/urls.dart';
import '../../../../services/network_caller/network_caller.dart';
import '../../../common/ui/controllers/auth_controller.dart';
import '../../data/models/sign_in_model.dart';

class OtpVerificationController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Logger _logger = Logger();

  Future<bool> verifyOtp(String email, String otp) async {
  bool isSuccess = false;
  _inProgress = true;
  update();

  Map<String, String> requestParams = {
    "email": email,
    "otp": otp,
  };

  final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
    Urls.verifyOtpUrl,
    body: requestParams,
  );
  if(response.isSuccess){
    isSuccess = true;
    _errorMessage = null;

    AuthSuccessModel authSuccessModel = AuthSuccessModel.fromJson(response.responseData);
    await Get.find<AuthController>().saveUserData(
      authSuccessModel.data!.token!,
      authSuccessModel.data!.user!,
    );

    String? token =  Get.find<AuthController>().accessToken;
    _logger.i("Token saved successfully: $token");

  }else{
    isSuccess = false;
    _errorMessage = response.errorMessage;
  }
  _inProgress = false;
  update();
  return isSuccess;
  }
}