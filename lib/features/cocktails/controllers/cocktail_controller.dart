import 'dart:io';
import 'dart:convert';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocktailController extends GetxController {
  static CocktailController get instance => Get.find();

  final Rx<File?> imageFile = Rx<File?>(null);

  List<CocktailModel> cocktails = [
    CocktailModel(
      id: 1,
      name: "Mojito Clásico",
      creationSteps: "Macerar menta con azúcar...",
      preparationTime: 5,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 125,
    ),
    CocktailModel(
      id: 2,
      name: "Margarita",
      creationSteps: "Mezclar tequila con limón...",
      preparationTime: 3,
      isNonAlcoholic: false,
      alcoholType: "Tequila",
      imageUrl: "https://images.unsplash.com/photo-1556855810-ac404aa91e85",
      likes: 98,
    ),
    CocktailModel(
      id: 3,
      name: "Piña Colada",
      creationSteps: "Licuar piña con ron...",
      preparationTime: 7,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 156,
    ),
    CocktailModel(
      id: 1,
      name: "Mojito Clásico",
      creationSteps: "Macerar menta con azúcar...",
      preparationTime: 5,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 125,
    ),
    CocktailModel(
      id: 2,
      name: "Margarita",
      creationSteps: "Mezclar tequila con limón...",
      preparationTime: 3,
      isNonAlcoholic: false,
      alcoholType: "Tequila",
      imageUrl: "https://images.unsplash.com/photo-1556855810-ac404aa91e85",
      likes: 98,
    ),
    CocktailModel(
      id: 3,
      name: "Piña Colada",
      creationSteps: "Licuar piña con ron...",
      preparationTime: 7,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 156,
    ),
    CocktailModel(
      id: 1,
      name: "Mojito Clásico",
      creationSteps: "Macerar menta con azúcar...",
      preparationTime: 5,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 125,
    ),
    CocktailModel(
      id: 2,
      name: "Margarita",
      creationSteps: "Mezclar tequila con limón...",
      preparationTime: 3,
      isNonAlcoholic: false,
      alcoholType: "Tequila",
      imageUrl: "https://images.unsplash.com/photo-1556855810-ac404aa91e85",
      likes: 98,
    ),
    CocktailModel(
      id: 3,
      name: "Piña Colada",
      creationSteps: "Licuar piña con ron...",
      preparationTime: 7,
      isNonAlcoholic: false,
      alcoholType: "Ron",
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
      likes: 156,
    ),
  ];

  void setImage(File file) async {
    imageFile.value = file;
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    imageUrl.text =
        'data:image/jpeg;base64,$base64Image'; // asigna directamente a imageUrl
  }

  final name = TextEditingController();
  final creationSteps = TextEditingController();
  final preparationTime = TextEditingController();
  final videoUrl = TextEditingController();
  final imageUrl = TextEditingController();
  final alcoholType = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var isNonAlcoholic = false.obs;
  var isLoading = false.obs;

  RxList<Map<String, dynamic>> selectedIngredients =
      <Map<String, dynamic>>[].obs;

  void toggleNonAlcoholic(bool value) {
    isNonAlcoholic.value = value;
    if (value) alcoholType.clear();
  }

  RxList<Map<String, dynamic>> manualIngredients = <Map<String, dynamic>>[].obs;

  void addManualIngredient(String name, String quantity) {
    if (name.isNotEmpty && quantity.isNotEmpty) {
      manualIngredients.add({'name': name, 'quantity': quantity});
    }
  }

  void clearForm() {
    name.clear();
    creationSteps.clear();
    preparationTime.clear();
    videoUrl.clear();
    imageUrl.clear();
    alcoholType.clear();
    isNonAlcoholic.value = false;
    selectedIngredients.clear();
    manualIngredients.clear();
  }

  Future<void> submitCocktail(String? jwt) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final userId = UserController.instance.user.value.id;

      final cocktail = CocktailModel(
        name: name.text.trim(),
        creationSteps: creationSteps.text.trim(),
        preparationTime: int.tryParse(preparationTime.text.trim()),
        isNonAlcoholic: isNonAlcoholic.value,
        alcoholType: isNonAlcoholic.value ? null : alcoholType.text.trim(),
        videoUrl: videoUrl.text.trim(),
        imageUrl: imageUrl.text.trim(),
        userId: userId,
        ingredients: manualIngredients,
      );

      await CocktailRepository.instance.createCocktail(cocktail, jwt);

      Get.snackbar("Éxito", "Receta creada correctamente");
      clearForm();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
