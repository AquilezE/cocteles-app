import 'package:cocteles_app/features/createUser/controllers/createUser_controller.dart';
import 'package:cocteles_app/utils/constants/sizes.dart';
import 'package:cocteles_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
        child: Column(
          children: [

            TextFormField(
              controller: controller.fullName,
              validator: (value) => Validator.validateEmptyText('Full Name', value),
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.email,
              validator: (value) => Validator.validateEmail(value),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Iconsax.direct),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Obx(() => TextFormField(
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              validator: (value) => Validator.validateLenght(value),
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            )),
            const SizedBox(height: Sizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.register(),
                child: const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
