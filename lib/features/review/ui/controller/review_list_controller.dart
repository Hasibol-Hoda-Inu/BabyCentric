import 'package:BabyCentric/features/review/data/models/review_list_model.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../../../services/network_caller/network_caller.dart';

class ReviewListController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Results> _results = [];
  List<Results> get results => _results;

  Future<bool> getReviewList(String productId) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> queryParams = {"product": productId};
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.reviewsUrl,
      queryParams: queryParams,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;

      final ReviewListModel reviewListModel = ReviewListModel.fromJson(
        response.responseData,
      );
      _results = reviewListModel.data?.results ?? [];
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
