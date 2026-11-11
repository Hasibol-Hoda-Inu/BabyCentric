import 'package:BabyCentric/features/home/data/models/slider_model.dart';
import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../data/models/slider_pagination_model.dart';

class SliderListController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SliderPaginationModel? _sliderPaginationModelModel;
  List<SliderModel> get sliderList =>
      _sliderPaginationModelModel?.data?.results ?? [];

  Future<bool> getBannerSliders() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.homeBannerSliders,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _sliderPaginationModelModel = SliderPaginationModel.fromJson(
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
