import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/createUser/controllers/createUser_controller.dart';
import 'package:cocteles_app/models/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel user;
  final controller = Get.put(RegisterController());

  EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    controller.fullName.text = user.username ?? '';
    controller.email.text = user.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(user),
              const SizedBox(height: 16),
              const Text(
                "Toca la imagen para actualizarla",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              _buildInputField(
                controller: controller.fullName,
                label: "Nombre de usuario",
                icon: Icons.person,
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                controller: controller.email,
                label: "Correo electrónico",
                icon: Icons.email,
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),

              // Campo de contraseña actual (nuevo)
              Obx(() => _buildInputField(
                    controller: controller.currentPassword,
                    label: "Contraseña actual",
                    icon: Icons.lock_outline,
                    obscureText: controller.hideCurrentPassword.value,
                    validator: (value) {
  if (controller.password.text.isNotEmpty) {
    if (value == null || value.isEmpty) {
      return 'Debe ingresar la contraseña actual';
    }
  }
  return null;
},

                    suffix: IconButton(
                      icon: Icon(
                        controller.hideCurrentPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        controller.hideCurrentPassword.value =
                            !controller.hideCurrentPassword.value;
                      },
                    ),
                  )),
              const SizedBox(height: 20),
              Obx(() => _buildInputField(
                    controller: controller.password,
                    label: "Nueva contraseña (opcional)",
                    icon: Icons.lock,
                    obscureText: controller.hidePassword.value,
                    suffix: IconButton(
                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                    ),
                  )),

              const SizedBox(height: 36),
              _buildSaveButton(user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    return Obx(() {
      final imageFile = controller.selectedImage.value;
      final profilePicture = user.profilePicture;

      return GestureDetector(
        onTap: controller.pickImage,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageFile != null
              ? FileImage(imageFile)
              : (profilePicture != null && profilePicture.isNotEmpty
                  ? NetworkImage(profilePicture)
                  : null) as ImageProvider?,
          child: (imageFile == null &&
                  (profilePicture == null || profilePicture.isEmpty))
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
      );
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        suffixIcon: suffix,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

 Widget _buildSaveButton(UserModel user) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      onPressed: () => controller.updateProfile(
        user.id!,
        user.profilePicture ?? '',
        user.role ?? '',
      ),
      icon: const Icon(Icons.save_alt),
      label: const Text("Guardar cambios"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

}
