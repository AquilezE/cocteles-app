import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de usuario')),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Platform.isWindows || Platform.isMacOS || Platform.isLinux
            ? buildDesktopLayout(user)
            : buildMobileLayout(user);
      }),
    );
  }

  Widget buildDesktopLayout(dynamic user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 1,
          child: Center(
            child: Icon(Icons.account_circle, size: 120, color: Colors.grey),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Información ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Text('Usuario: ${user.username}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Correo: ${user.email}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Rol: ${user.role}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout(dynamic user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Información', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre usuario: ${user.username}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Correo: ${user.email}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Rol: ${user.role}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

