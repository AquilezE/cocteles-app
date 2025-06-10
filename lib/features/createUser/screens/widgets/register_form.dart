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
              validator: (value) =>
                  Validator.validateEmptyText('Full Name', value),
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.email,
              validator: (value) => Validator.validateEmail(value),
              decoration: const InputDecoration(
                labelText: "Correo",
                prefixIcon: Icon(Iconsax.direct),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                validator: (value) => Validator.validateLenght(value),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Foto de perfil',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final image = controller.selectedImage.value;
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: image != null
                            ? () => Get.dialog(
                                  Dialog(child: Image.file(image)),
                                )
                            : null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: image != null
                              ? Image.file(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Iconsax.gallery,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => controller.pickImage(),
                        icon: const Icon(Iconsax.gallery_add),
                        label: const Text('Seleccionar'),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  final image = controller.selectedImage.value;
                  return image != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            image.path.split('/').last,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const SizedBox();
                }),
              ],
            ),

            const SizedBox(height: Sizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    controller.register(controller.selectedImage.value),
                child: const Text("Crear cuenta"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

