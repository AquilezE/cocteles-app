import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  final UserController userController = Get.put(UserController());
  static AuthenticationRepository get instance => Get.find();
  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    deviceStorage.writeIfNull('IS_FIRST_TIME', true);
    deviceStorage.writeIfNull('REMEMBER_ME', false);

    if (deviceStorage.read('IS_FIRST_TIME') == true) {
      deviceStorage.write('IS_FIRST_TIME', false);
    }

    if (deviceStorage.read("REMEMBER_ME") == true) {
      var emailFromLocalStorage = deviceStorage.read('EMAIL_RECUERDAME');
      var passwordFromLocalStorage = deviceStorage.read('PASSWORD_RECUERDAME');
      if (emailFromLocalStorage != null && emailFromLocalStorage != null) {
        UserCredentials userCredentials =
            await AuthenticationRepository.instance.loginWithEmailAndPassword(
                emailFromLocalStorage, passwordFromLocalStorage);

        deviceStorage.write('jwt', userCredentials.jwt);
        deviceStorage.write('username', userCredentials.username);

        userController.userCredentials = userCredentials;
        userController.fetchUserData();

        print('User credentials: ${userCredentials.toJson()}');

        Get.offAll(() => NavigationMenu());
        return;
      } else {
        Get.offAll(() => const LoginPage());
      }
    }

    Get.offAll(() => const LoginPage());
    return;
  }

  Future<UserCredentials> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      const endpoint = 'api/v1/auth/login';
      Map<String, String> body = {
        'email': email,
        'password': password,
      };

      var response = await AppHttpHelper.post(endpoint, body, null);
      return UserCredentials.fromJson(response);
    } catch (e) {
      print(e);
      if (e is HttpException) {
        throw HttpException(e.statusCode, e.responseBody);
      } else {
        Get.offAll(() => const LoginPage());
        throw Exception('Failed to login');
      }
    }
  }
}
