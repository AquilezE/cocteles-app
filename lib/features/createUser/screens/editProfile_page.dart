import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/createUser/controllers/createUser_controller.dart';
import 'package:cocteles_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel user;
  final controller = Get.put(RegisterController());

  EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    controller.fullName.text = user.username ?? '';
    controller.email.text = user.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 102, 61),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(() {
                  final imageFile = controller.selectedImage.value;
                  final hasNewImage = imageFile != null;
                  final currentPhoto = user.profilePicture;

                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 239, 103, 62),
                      backgroundImage: hasNewImage
                          ? FileImage(imageFile)
                          : (currentPhoto != null && currentPhoto.isNotEmpty
                              ? NetworkImage(currentPhoto)
                              : null) as ImageProvider?,
                      child: (!hasNewImage && (currentPhoto == null || currentPhoto.isEmpty))
                          ? const Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              const Center(child: Text("Toca la imagen para cambiarla")),
              const SizedBox(height: 24),

              ProfileInputCard(
                icon: Icons.person_outline,
                label: 'Nombre de usuario',
                controller: controller.fullName,
                validator: (value) =>
                    value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              ProfileInputCard(
                icon: Icons.email_outlined,
                label: 'Correo electrónico',
                controller: controller.email,
                validator: (value) =>
                    value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              Obx(() => ProfileInputCard(
                    icon: Icons.lock_outline,
                    label: 'Nueva contraseña (opcional)',
                    controller: controller.password,
                    obscureText: controller.hidePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(controller.hidePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                    ),
                  )),
              const SizedBox(height: 32),
              Center(
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => controller.updateProfile(user.id!, user.profilePicture ?? ''),
      icon: const Icon(Icons.save),
      label: const Text('Guardar cambios'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
class ProfileInputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const ProfileInputCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}