import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/services/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../../../application/urls.dart';
import '../../data/models/wishlist_item_list_data_model.dart';

class WishlistItemListController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  bool get initialInProgress => _page == 1 && _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final int _count = 9;
  int _page = 0;
  int? _lastPage;

  final List<WishlistItemModel> _wishlistDataModel = [];
  List<WishlistItemModel> get wishlistItemList => _wishlistDataModel;

  Future<bool> getWishlistItemList(String token) async {
    _page++;
    if (_lastPage != null && _page > _lastPage!) return false;

    bool isSuccess = false;
    _inProgress = true;
    _wishlistDataModel.clear();
    update();

    Map<String, dynamic> queryParams = {"count": _count, "page": _page};

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.wishlistUrl,
      accessToken: token,
      queryParams: queryParams,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;

      WishlistItemListDataModel wishlistDataModel =
          WishlistItemListDataModel.fromJson(response.responseData);
      _wishlistDataModel.addAll(wishlistDataModel.data?.results ?? []);

      if (wishlistDataModel.data?.lastPage != null) {
        _lastPage = wishlistDataModel.data!.lastPage!;
      }
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshWishlistItemList() async {
    _page = 0;
    _lastPage = null;
    _wishlistDataModel.clear();
    String token = Get.find<AuthController>().accessToken!;
    return getWishlistItemList(token);
  }
}
