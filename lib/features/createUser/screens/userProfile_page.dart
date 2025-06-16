import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/features/createUser/screens/editProfile_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de usuario'), automaticallyImplyLeading: false),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          print("DEBUG: user es null");
          return const Center(child: CircularProgressIndicator());
        }

        print("DEBUG: user.username = ${user.username}");
        print("DEBUG: user.profilePicture = ${user.profilePicture}");

        return Column(
          children: [
            Expanded(
              child: Platform.isWindows || Platform.isMacOS || Platform.isLinux
                  ? buildDesktopLayout(user)
                  : buildMobileLayout(user),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => EditProfileScreen(user: user));
              },
              icon: const Icon(Icons.edit),
              label: const Text("Editar perfil"),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12)),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

Widget buildDesktopLayout(dynamic user) {
  final hasProfilePicture = user.profilePicture != null && user.profilePicture!.isNotEmpty;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 1,
        child: Center(
          child: hasProfilePicture
              ? ClipOval(
                  child: Image.network(
                    user.profilePicture!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.account_circle, size: 120, color: Colors.grey);
                    },
                  ),
                )
              : const Icon(Icons.account_circle, size: 120, color: Colors.grey),
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
              const Text('Información', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Text('Usuario: ${user.username}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Correo: ${user.email}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Rol: ${user.role}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Biografía: ${user.bio?.isNotEmpty == true ? user.bio : "Sin biografía"}',
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildMobileLayout(dynamic user) {
  final hasProfilePicture = user.profilePicture != null && user.profilePicture!.isNotEmpty;

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          hasProfilePicture
              ? ClipOval(
                  child: Image.network(
                    user.profilePicture!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.account_circle, size: 100, color: Colors.grey);
                    },
                  ),
                )
              : const Icon(Icons.account_circle, size: 100, color: Colors.grey),
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
                const SizedBox(height: 10),
                Text('Biografía: ${user.bio?.isNotEmpty == true ? user.bio : "Sin biografía"}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
