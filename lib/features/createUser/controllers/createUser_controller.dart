import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final hidePassword = true.obs;

  void register() {
    if (formKey.currentState!.validate()) {
      // Simulación de lógica de registro
      print("Registering: ${fullName.text}, ${email.text}");
      Get.snackbar("Success", "Account created successfully",
        snackPosition: SnackPosition.BOTTOM);
      // Aquí iría lógica real para crear cuenta con tu backend
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
