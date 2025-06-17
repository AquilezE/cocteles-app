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
import 'dart:async';

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
  final GlobalKey<FormState> changePassFormKey = GlobalKey<FormState>();
  final bio = TextEditingController();

Future<bool> showCodeVerificationDialog() async {
  final codeController = TextEditingController();
  final completer = Completer<bool>();

  await showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Verificación de correo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingresa el código que te enviamos al correo.'),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Código'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await sendVerificationCode();
                    setState(() {}); 
                  },
                  child: const Text("¿No recibiste el código? Reenviar"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!completer.isCompleted) completer.complete(false);
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool success = await verifyCode(codeController.text.trim());
                  if (success) {
                    if (!completer.isCompleted) completer.complete(true);
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar("Error", "Código incorrecto o expirado",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
          );
        },
      );
    },
  );

  return completer.future;
}


  Future<void> sendVerificationCode() async {
    try {
      await UserRepository.instance.sendVerificationEmail(email.text.trim());
      Get.snackbar("Éxito", "Código de verificación enviado al correo", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "No se pudo enviar el código", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> verifyCode(String code) async {
    try {
      await UserRepository.instance.verifyEmailCode(email.text.trim(), code);
      Get.snackbar("Éxito", "Correo verificado correctamente", snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      Get.snackbar("Error", "Código incorrecto o expirado", snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
  void register(File? photoFile) async {
  if (formKey.currentState!.validate()) {
    try {
      await sendVerificationCode();

      final verified = await showCodeVerificationDialog();

      if (!verified) {
        Get.snackbar("Error", "La verificación no fue exitosa.", snackPosition: SnackPosition.BOTTOM);
        return;
      }

      String? photoUrl;

      if (photoFile != null) {
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
      Get.snackbar("Error", "No se pudo crear la cuenta, correo o nombre de usuarios repetidos", snackPosition: SnackPosition.BOTTOM);
    }
  }
}


Future<bool> changeUserPassword(int userId) async {
  final jwt = box.read('token');

  try {
    final success = await UserRepository.instance.changePassword(
      userId: userId,
      currentPassword: currentPassword.text.trim(),
      newPassword: password.text.trim(),
      jwt: jwt,
    );

    if (success) {
      currentPassword.clear();
      password.clear();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    Get.snackbar("Error", "No se pudo cambiar la contraseña", snackPosition: SnackPosition.BOTTOM);
    return false;
  }
}



void pickImage() async {
  final allowedExtensions = ['jpg', 'jpeg', 'png'];

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    final imageGroup = XTypeGroup(
      label: 'images',
      extensions: allowedExtensions,
    );
    final XFile? pickedFile = await openFile(acceptedTypeGroups: [imageGroup]);
    if (pickedFile != null) {
      final extension = pickedFile.name.split('.').last.toLowerCase();
      if (allowedExtensions.contains(extension)) {
        selectedImage.value = File(pickedFile.path);
      } else {
        Get.snackbar("Formato no válido", "Selecciona una imagen JPG o PNG");
      }
    }
  } else {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final extension = pickedFile.name.split('.').last.toLowerCase();
      if (allowedExtensions.contains(extension)) {
        selectedImage.value = File(pickedFile.path);
      } else {
        Get.snackbar("Formato no válido", "Selecciona una imagen JPG o PNG");
      }
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

    final updatedUser = UserModel(
      id: userId,
      username: fullName.text.trim(),
      email: email.text.trim(),
      profilePicture: photoUrl,
      role: currentRole,
      bio: bio.text.trim(),
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
    Get.snackbar("Error", "Error al actualizar el perfil:", snackPosition: SnackPosition.BOTTOM);
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
    profile_picture_path: '',
    bio: '', 
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
        throw Exception('Si información de la sesión');
      }

      final userModel = await UserRepository.instance.getUserDetails(username, jwt);

      user.value = UserRegistration(
        username: userModel.username,
        email: userModel.email,
        password: '********',
        role: userModel.role,
        profile_picture_path: userModel.profilePicture,
        bio: userModel.bio, 
      );

    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
