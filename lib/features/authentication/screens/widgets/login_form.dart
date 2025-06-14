import 'package:cocteles_app/features/authentication/controllers/login_controller.dart';
import 'package:cocteles_app/utils/constants/sizes.dart';
import 'package:cocteles_app/utils/validators/validator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/createUser/screens/createUser_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Sizes.spaceBtwSections),
          child: Column(
            children: [
              TextFormField(
                controller: controller.email,
                validator: (value) =>  Validator.validateEmail(value),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: "Correo",),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  controller: controller.password,
                  validator: (value) => Validator.validateLenght(value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye))),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields / 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                      const Text("Recuérdame"),
                    ],
                  ),

                  TextButton(
                      onPressed: () => Get.to(() => const ()),
                      child: const Text("¿Olvidaste tu contraseña?")),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.signIn(),
                      child: const Text("Iniciar sesión"))),

              const SizedBox(height: Sizes.spaceBtwItems),

              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const RegisterScreen()),
                      child: const Text("Crear cuenta"))),
            ],
          ),
        ));
  }
}