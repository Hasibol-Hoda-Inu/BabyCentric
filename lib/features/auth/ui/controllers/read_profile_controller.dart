import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../../../services/network_caller/network_caller.dart';
import '../../data/models/profile_model.dart';

class ReadProfileController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  Future<bool> readProfile(String token) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
        Urls.readProfile,
        accessToken: token,
    );
    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;
      if(response.responseData["data"] == null){
        _profileModel = null;
      }else{
        _profileModel = ProfileModel.fromJson(response.responseData["data"]);
      }
    }else{
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}