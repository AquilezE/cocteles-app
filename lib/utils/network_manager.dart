import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

//maybe get a loader

class NetworkManager extends GetxController{

static NetworkManager get instance => Get.find();

final Connectivity _connectivity = Connectivity();
late StreamSubscription<ConnectivityResult> _connectivitySuscription;
final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

@override
  void onInit() {
    
    super.onInit();
    _connectivitySuscription = _connectivity.onConnectivityChanged
        .map((results) => results.isNotEmpty ? results.first : ConnectivityResult.none)
        .listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;
    if (result == ConnectivityResult.none) {
      Get.snackbar('No Internet', 'Please check your internet connection');
    }
  }

  Future<bool> isConnected() async {
      try{
        final connectivityResult = await _connectivity.checkConnectivity();
        return connectivityResult.contains(ConnectivityResult.none) == false;
      }on PlatformException catch (e) {
        print('Error: $e');
        return false;
      }

  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySuscription.cancel();
  }

}