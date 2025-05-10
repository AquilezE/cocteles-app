import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cocteles_app/utils/http_client.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();
  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect(){
    deviceStorage.writeIfNull('IS_FIRST_TIME', true);

/*
    if(deviceStorage.read('IS_FIRST_TIME') == true){
      //Get.offAll(() => const OnBoardingPage());
      }else{
        Get.offAll(() => const LoginPage());
      }
*/
    Get.offAll(() => const LoginPage());

  }

  Future<UserCredentials> loginWithEmailAndPassword(String email, String password) async{
    try{
      const endpoint = 'api/v1/auth/login';
      Map<String, String> body = {
        'email': email,
        'password': password,
      };

      var response = await AppHttpHelper.post(endpoint, body, null);
      return UserCredentials.fromJson(response);

    }catch(e){
      print(e);
      if (e is HttpException) {
        throw HttpException(
          e.statusCode,
          e.responseBody
        );
      } else {
        throw Exception('Failed to login');
      }
    }
  }

  
}