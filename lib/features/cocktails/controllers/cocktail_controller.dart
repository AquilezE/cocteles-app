import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CocktailController extends GetxController {
  static CocktailController get instance => Get.find();

  final Rx<File?> imageFile = Rx<File?>(null);
  final Rx<XFile?> video = Rx<XFile?>(null);

  final name = TextEditingController();
  final creationSteps = TextEditingController();
  final preparationTime = TextEditingController();
  final imageUrl = TextEditingController();
  final alcoholType = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isNonAlcoholic = false.obs;
  var isLoading = false.obs;

  RxList<Map<String, dynamic>> selectedIngredients = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> manualIngredients = <Map<String, dynamic>>[].obs;

  late final player = Player();
  late final videoController = VideoController(player);

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  void initializeVideoController() {
    if (video.value != null) {
      player.open(Media(video.value!.path));
    }
  }

  Future<XFile> getVideoDownloadedFuture(String videoUrl, String jwt) async {
    return CocktailRepository.instance.downloadVideo(videoUrl, jwt);
  }

  void toggleNonAlcoholic(bool value) {
    isNonAlcoholic.value = value;
    if (value) alcoholType.clear();
  }

  void addManualIngredient(String name, String quantity) {
    if (name.isNotEmpty && quantity.isNotEmpty) {
      manualIngredients.add({'name': name, 'quantity': quantity});
    }
  }

  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/v1/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', file.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      final baseUrl = '${dotenv.env['BASE_URL']}';
      return "$baseUrl${data['imageUrl']}";
    } else {
      return null;
    }
  }

  Future<void> pickAndSetImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final extension = picked.name.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        Get.snackbar("Formato no válido", "Solo se permiten imágenes JPG, JPEG o PNG.");
        return;
      }

      final file = File(picked.path);
      imageFile.value = file;

      try {
        final uploadedUrl = await CocktailRepository.instance.uploadImage(file);
        imageUrl.text = uploadedUrl ?? '';
      } catch (e) {
        Get.snackbar("Error", "Ocurrió un error al subir la imagen, por favor intente más tarde.");
      }
    }
  }

  Future<void> pickAndSetVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      final extension = picked.name.split('.').last.toLowerCase();
      if (extension != 'mp4') {
        Get.snackbar("Formato no válido", "Solo se permiten videos en formato MP4.");
        return;
      }

      video.value = picked;
      initializeVideoController();
    }
  }

  Future<void> submitCocktail(String jwt, BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    if (imageFile.value == null) {
      Get.snackbar("Error", "Debes seleccionar una imagen del cóctel.");
      isLoading.value = false;
      return;
    }

    if (video.value == null) {
      Get.snackbar("Error", "Debes seleccionar un video de preparación.");
      isLoading.value = false;
      return;
    }

    if (manualIngredients.isEmpty) {
      Get.snackbar("Error", "Debes agregar al menos un ingrediente con su cantidad.");
      isLoading.value = false;
      return;
    }

    if (!isNonAlcoholic.value && alcoholType.text.trim().isEmpty) {
      Get.snackbar("Error", "Debes seleccionar un tipo de alcohol o si el cóctel es sin alcohol.");
      isLoading.value = false;
      return;
    }

    final videoUrlString = '${DateTime.now()}-${name.text}${path.extension(video.value!.name)}'
        .replaceAll(' ', '')
        .replaceAll(':', '');

    try {
      final userId = UserController.instance.user.value.id;

      final cocktail = CocktailModel(
        name: name.text.trim(),
        creationSteps: creationSteps.text.trim(),
        preparationTime: int.tryParse(preparationTime.text.trim()),
        isNonAlcoholic: isNonAlcoholic.value,
        alcoholType: isNonAlcoholic.value ? null : alcoholType.text.trim(),
        videoUrl: videoUrlString,
        imageUrl: imageUrl.text.trim(),
        userId: userId,
        ingredients: manualIngredients,
      );

      await CocktailRepository.instance.createCocktail(cocktail, jwt);
      await CocktailRepository.instance.uploadVideo(video.value!, videoUrlString, jwt);

      Get.snackbar("Éxito", "La receta de cóctel ha sido enviada a revisión. Recibirás una respuesta por correo tan pronto como sea posible.");
      await Future.delayed(const Duration(seconds: 3));

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Get.offAllNamed('/');
      }
    } catch (e) {
      Get.snackbar("Error", '$e');
      await Future.delayed(const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }
}