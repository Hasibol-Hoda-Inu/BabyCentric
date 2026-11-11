import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  final isConnected = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      isConnected.value = status == InternetStatus.connected;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}