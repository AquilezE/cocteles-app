import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:cocteles_app/features/createUser/models/UserRegistration.dart'; 

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

