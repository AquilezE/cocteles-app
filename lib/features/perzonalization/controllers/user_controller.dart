import 'dart:io';

import 'package:cocteles_app/services/firebase_api.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/models/user_model.dart';
import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final localStorage = GetStorage();

  final userRepostory = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;
  UserCredentials? userCredentials;

  Future<void> getUserStatisticsData() async {
    try {} catch (e) {
      print(e);
    }
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await userRepostory.getUserDetails(
          userCredentials!.username, userCredentials!.jwt);
      this.user(userData);
      print(userData);
    } catch (e) {
      user(UserModel.empty());
      print(e);
    }
  }

  Future<void> logOut() async {
    try {
      localStorage.remove("EMAIL_RECUERDAME");
      localStorage.remove("PASSWORD_RECUERDAME");
      localStorage.write("REMEMBER_ME", false);
      localStorage.remove("jwt");
      localStorage.remove("username");

      if (!Platform.isWindows && !Platform.isLinux) {
        final firebaseApi = FirebaseApi();
        firebaseApi.unregisterDevice(userCredentials!.jwt);
        final _deviceIdKey = 'device_id';
        localStorage.remove(_deviceIdKey);
      }

      userCredentials = null;
      user(UserModel.empty());
    } catch (e) {
      print(e);
    }
  }
}
