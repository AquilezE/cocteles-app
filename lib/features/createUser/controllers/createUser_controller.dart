import 'dart:io';

import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:cocteles_app/features/createUser/models/UserRegistration.dart';
import 'package:get_storage/get_storage.dart'; 
import 'package:cocteles_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;
import 'package:file_selector/file_selector.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final box = GetStorage();
  final selectedImage = Rx<File?>(null);
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  RxBool hideCurrentPassword = true.obs; 

  void changeUserPassword(int userId) async {
  final jwt = box.read('token');

  try {
    await UserRepository.instance.changePassword(
      userId: userId,
      currentPassword: currentPassword.text.trim(),
      newPassword: newPassword.text.trim(),
      jwt: jwt,
    );

    Get.snackbar("Éxito", "Contraseña actualizada correctamente", snackPosition: SnackPosition.BOTTOM);
  } catch (e) {
    Get.snackbar("Error", "No se pudo cambiar la contraseña: $e", snackPosition: SnackPosition.BOTTOM);
  }
}

void pickImage() async {
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    final XTypeGroup imageGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png'],
    );
    final XFile? pickedFile = await openFile(acceptedTypeGroups: [imageGroup]);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  } else {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
}

void register(File? photoFile) async {
  if (formKey.currentState!.validate()) {
    try {
      String? photoUrl;

      if(photoFile != null) {
        photoUrl = await UserRepository.instance.uploadUserPhoto(photoFile);
        print("Imagen subida: $photoUrl"); 
      }

      final newUser = UserRegistration(
      username: fullName.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
      profile_picture_path: photoUrl,
      );
      await UserRepository.instance.createUser(newUser);

      Get.snackbar("Éxito", "Cuenta creada correctamente", snackPosition: SnackPosition.BOTTOM);
      Get.to(() => LoginPage());

    } catch (e) {
      Get.snackbar("Error", "No se pudo crear la cuenta: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
void updateProfile(int userId, String currentPhotoUrl, String currentRole) async {
  if (!formKey.currentState!.validate()) return;

  try {
    final jwt = box.read('token');
    String? photoUrl = currentPhotoUrl;

    if (selectedImage.value != null) {
      photoUrl = await UserRepository.instance.uploadUserPhoto(selectedImage.value!);
      selectedImage.value = null;
    }
    if (password.text.isNotEmpty) {
      if (currentPassword.text.isEmpty) {
        Get.snackbar("Error", "Debe ingresar la contraseña actual para cambiar la contraseña");
        return;
      }

      try {
        await UserRepository.instance.changePassword(
          userId: userId,
          currentPassword: currentPassword.text.trim(),
          newPassword: password.text.trim(),
          jwt: jwt,
        );
        Get.snackbar("Éxito", "Contraseña actualizada correctamente", snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Error", "No se pudo cambiar la contraseña: $e", snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }

    final updatedUser = UserModel(
      id: userId,
      username: fullName.text.trim(),
      email: email.text.trim(),
      profilePicture: photoUrl,
      role: currentRole,
    );
    final result = await UserRepository.instance.updateUser(updatedUser, jwt);
    final userController = Get.find<UserController>();
    userController.user.value = result;

    Get.snackbar("Éxito", "Perfil actualizado correctamente", snackPosition: SnackPosition.BOTTOM);
    await Future.delayed(const Duration(seconds: 2));
    if (Get.overlayContext != null && Navigator.of(Get.overlayContext!).canPop()) {
      Navigator.of(Get.overlayContext!).pop();
    }

  } catch (e) {
    Get.snackbar("Error", "Error al actualizar el perfil: $e", snackPosition: SnackPosition.BOTTOM);
  }
}




  @override
  void onClose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }


}
class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final Rx<UserRegistration> user = UserRegistration(
    username: '',
    email: '',
    password: '',
    role: '',
  ).obs;

  final isLoading = true.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }
  

  void fetchUserProfile() async {
    try {
      isLoading.value = true;

      final username = storage.read('username');
      final jwt = storage.read('jwt');

      if (username == null || jwt == null) {
        throw Exception('No session data found');
      }

      final userModel = await UserRepository.instance.getUserDetails(username, jwt);

      user.value = UserRegistration(
  username: userModel.username,
  email: userModel.email,
  password: '********',
  role: userModel.role,
  profile_picture_path: userModel.profilePicture,
);

    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

