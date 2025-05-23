import 'dart:io';
import 'dart:convert';
import 'package:cocteles_app/navigation_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cocteles_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/utils/network_manager.dart';


class LoginController extends GetxController {

  final UserController userController = Get.put(UserController());

  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {

    var emailFromLocalStorage = localStorage.read('EMAIL_RECUERDAME');
    var passwordFromLocalStorage = localStorage.read('PASSWORD_RECUERDAME');
    if (emailFromLocalStorage != null && emailFromLocalStorage != null) {
      email.text = emailFromLocalStorage;
      password.text = passwordFromLocalStorage;
      rememberMe.value = true;
    }

    super.onInit();
  }

  Future<void> signIn() async {

    try{
      
      final isConnected = await NetworkManager.instance.isConnected();

      
      print('isConnected: $isConnected');

      if (!isConnected) {
        Get.snackbar('No Internet', 'Please check your internet connection');
        return;
      }
      
      if(!formKey.currentState!.validate()){
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

      if (rememberMe.value){
        localStorage.write("EMAIL_RECUERDAME", emailString);
        localStorage.write("PASSWORD_RECUERDAME", passwordString); 
      }else{
        localStorage.remove("EMAIL_RECUERDAME");
        localStorage.remove("PASSWORD_RECUERDAME");
      }

      print('Email: $emailString');
      print('Password: $passwordString');

      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(emailString, passwordString);

      localStorage.write('jwt', userCredentials.jwt);
      localStorage.write('username', userCredentials.username);
      
      userController.userCredentials = userCredentials;
      userController.fetchUserData();

      Get.to(() => NavigationMenu());



    }catch(e){
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred while signing in');
    }
  }



}