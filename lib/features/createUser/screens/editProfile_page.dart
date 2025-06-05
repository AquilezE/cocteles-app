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
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
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

              // Botón para abrir diálogo cambiar contraseña
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _showChangePasswordDialog(context),
                  icon: const Icon(Icons.lock_reset),
                  label: const Text("Cambiar Contraseña"),
                ),
              ),

              const SizedBox(height: 36),

              _buildSaveButton(user),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final controller = this.controller;

    controller.currentPassword.clear();
    controller.password.clear();
    controller.hideCurrentPassword.value = true;
    controller.hidePassword.value = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cambiar Contraseña"),
        content: Form(
          key: controller.changePassFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => _buildInputField(
                    controller: controller.currentPassword,
                    label: "Contraseña actual",
                    icon: Icons.lock_outline,
                    obscureText: controller.hideCurrentPassword.value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                    suffix: IconButton(
                      icon: Icon(
                        controller.hideCurrentPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                    label: "Nueva contraseña",
                    icon: Icons.lock,
                    obscureText: controller.hidePassword.value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                    suffix: IconButton(
                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final success =  controller.changeUserPassword(user.id!);
              if (await success) {
                Navigator.of(context).pop();
                Get.snackbar("Éxito", "Contraseña actualizada correctamente");
              }
            },
            child: const Text("Guardar"),
          ),
        ],
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
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
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
