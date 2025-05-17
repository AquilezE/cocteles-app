import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:cocteles_app/features/createUser/models/UserRegistration.dart';
import 'package:get_storage/get_storage.dart'; 

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;

  void register() async {
    if (formKey.currentState!.validate()) {
      try {
        final newUser = UserRegistration(
          username: fullName.text.trim(),
          email: email.text.trim(),
          password: password.text.trim(),
        );

        final userCredentials = await UserRepository.instance.createUser(newUser);

        Get.snackbar("Success", "Account created successfully",
          snackPosition: SnackPosition.BOTTOM);

         Get.to(() => LoginPage());

      } catch (e) {
        Get.snackbar("Error", "Failed to create account: $e",
          snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  void onClose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }


}
class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final Rx<UserRegistration> user = UserRegistration(
    username: '',
    email: '',
    password: '',
    role: '',
  ).obs;

  final isLoading = true.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try {
      isLoading.value = true;

      final username = storage.read('username');
      final jwt = storage.read('jwt');

      if (username == null || jwt == null) {
        throw Exception('No session data found');
      }

      final userModel = await UserRepository.instance.getUserDetails(username, jwt);

      user.value = UserRegistration(
        username: userModel.username,
        email: userModel.email,
        password: '********',
        role: userModel.role,
      );
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

