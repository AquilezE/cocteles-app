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
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller.fullName,
                decoration: const InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.email,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration: const InputDecoration(labelText: 'Nueva contraseña (opcional)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => controller.updateProfile(user.id!),
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
