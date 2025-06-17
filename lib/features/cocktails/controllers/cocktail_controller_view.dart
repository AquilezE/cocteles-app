import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/features/stats/controllers/StatsController.dart';
import 'package:cocteles_app/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:image_picker/image_picker.dart';

class CocktailDetailController extends GetxController {
  RxList<CommentModel> comments = <CommentModel>[].obs;
  RxList<CocktailModel> cocktails = <CocktailModel>[].obs;

  static UserController get userController => Get.find<UserController>();
  static StatsController get statsController => Get.find<StatsController>();

  XFile? video;
  CocktailModel? cocktail;
  RxBool hasLiked = false.obs;

  late String videoUrl;
  var isLoading = false.obs;
  final commentController = TextEditingController();

  Future<XFile> getVideoDownloadedFuture(String videoUrl, String jwt) async {
    return CocktailRepository.instance.downloadVideo(videoUrl, jwt);
  }
  
  Future<void> fetchCocktailById(int cocktailId, String jwt) async {
    try {
      final data = await CocktailRepository.instance.getCocktailById(cocktailId, jwt);
      cocktail = data;
      cocktails.refresh();
    } catch (e) {
      Get.snackbar("Error", "No se pudo cargar el cóctel. Intenta más tarde.");
    }
  }

  Future<void> fetchAcceptedCocktails() async {
    isLoading.value = true;
    try {
      final jwt = UserController.instance.userCredentials!.jwt;
      cocktails.value = await CocktailRepository.instance.getAcceptedCocktails(jwt);
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al cargar los cócteles, por favor intente más tarde.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFilteredCocktails({
    String? alcoholType,
    String? name,
    int? maxPreparationTime,
    bool? isNonAlcoholic,
  }) async {
    isLoading.value = true;

    try {
      final jwt = UserController.instance.userCredentials!.jwt;

      cocktails.value = await CocktailRepository.instance.getFilteredCocktails(
        alcoholType: alcoholType,
        name: name,
        maxPreparationTime: maxPreparationTime,
        isNonAlcoholic: isNonAlcoholic,
        jwt: jwt,
      );
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al buscar los cócteles, por favor intente más tarde.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfLiked(int cocktailId, int userId) async {
    try {
      hasLiked.value = await CocktailRepository.instance.hasUserLikedCocktail(cocktailId, userId);
    } catch (e) {
      Get.snackbar("Error", "Estamos teniendo problemas, por favor vuelve más tarde.");
    }
  }

   Future<void> toggleLike(int cocktailId, String jwt) async {
    try {
      if (hasLiked.value) {
        await CocktailRepository.instance.unlikeCocktail(cocktailId, jwt);
        hasLiked.value = false;
        cocktail?.likes = (cocktail?.likes ?? 1) - 1;
      } else {
        await CocktailRepository.instance.likeCocktail(cocktailId, jwt);
        hasLiked.value = true;
        cocktail?.likes = (cocktail?.likes ?? 0) + 1;
      }
      cocktails.refresh();
      await statsController.fetchTopLikedRecipes();
    } catch (e) {
      Get.snackbar("Error", "Estamos teniendo problemas, por favor vuelve más tarde.");
    }
  }

  Future<void> fetchComments(int cocktailId, String jwt) async {
    try {
      final data = await CocktailRepository.instance.getCommentsByCocktailId(cocktailId, jwt);
      comments.value = data;
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al cargar los comentarios, por favor intente más tarde.");
    }
  }

  Future<void> deleteCocktail(int cocktailId) async {
    final jwt = UserController.instance.userCredentials!.jwt;
    try {
      await CocktailRepository.instance.deleteCocktail(cocktailId, jwt);
      Get.back();
      Get.snackbar("Éxito", "El cóctel ha sido eliminado correctamente.");
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al eliminar el cóctel, por favor intente más tarde.");
    }
  }

  Future<void> addComment(int cocktailId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final jwt = UserController.instance.userCredentials!.jwt;
    final userId = UserController.instance.user.value.id;

    try {
      await CocktailRepository.instance.addComment(
        cocktailId: cocktailId,
        userId: userId!,
        text: text,
        jwt: jwt,
      );

      commentController.clear();
      await fetchComments(cocktailId, jwt);
      Get.snackbar("Éxito", "Comentario enviado");
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al enviar el comentario, por favor intente más tarde.");
    }
  }
}