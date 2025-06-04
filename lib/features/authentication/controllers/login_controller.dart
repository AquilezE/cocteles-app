import 'dart:io';
import 'dart:convert';
import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:cocteles_app/navigation_menu.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cocteles_app/services/firebase_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cocteles_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/utils/network_manager.dart';

class LoginController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseApi firebaseApi = FirebaseApi();

  var userCredentials;

  @override
void onInit() async {
  super.onInit();

  var emailFromLocalStorage = localStorage.read('EMAIL_RECUERDAME');
  var passwordFromLocalStorage = localStorage.read('PASSWORD_RECUERDAME');

  if (emailFromLocalStorage != null && passwordFromLocalStorage != null) {
    email.text = emailFromLocalStorage;
    password.text = passwordFromLocalStorage;
    rememberMe.value = true;

    try{
    userCredentials = await AuthenticationRepository.instance
        .loginWithEmailAndPassword(
            emailFromLocalStorage, passwordFromLocalStorage);
            }catch(ex){
                  Get.to(() => LoginPage());

            }
  }

  final jwt = localStorage.read<String>('jwt');
  print(jwt);
  if (jwt != null) {
    if (!Platform.isWindows) {
      firebaseApi.tokenRefreshStream.listen((newToken) {
        firebaseApi.registerDevice(jwt);
      });
    }
  }

  if (jwt != null && userCredentials != null) { 
    userController.userCredentials = userCredentials;
    userController.fetchUserData();
    Get.to(() => LoginPage());
  }
}

  Future<void> signIn() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        Get.snackbar('No Internet', 'Please check your internet connection');
        return;
      }

      if (!formKey.currentState!.validate()) {
        return;
      }

      String emailString = email.text.trim();
      String passwordString = password.text.trim();

/*
      bool response = await AuthenticationRepository.instance.checkEmailVerified(emailString);

      if (!response) {
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
        return;
      }
*/

      if (rememberMe.value) {
        localStorage.write("EMAIL_RECUERDAME", emailString);
        localStorage.write("PASSWORD_RECUERDAME", passwordString);
        localStorage.write("REMEMBER_ME", true);
      } else {
        localStorage.remove("EMAIL_RECUERDAME");
        localStorage.remove("PASSWORD_RECUERDAME");
        localStorage.write("REMEMBER_ME", false);
      }

      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(emailString, passwordString);

      localStorage.write('jwt', userCredentials.jwt);
      localStorage.write('username', userCredentials.username);

      userController.userCredentials = userCredentials;
      userController.fetchUserData();

      await firebaseApi.registerDevice(userCredentials.jwt);

      Get.to(() => NavigationMenu());
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred while signing in');
    }
  }
}
