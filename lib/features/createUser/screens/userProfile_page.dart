import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/createUser/controllers/createUser_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Obx(() {
        final user = controller.user.value;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${user.username}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Role: ${user.role}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Back'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
