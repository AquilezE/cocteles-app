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
  static UserController get userController => Get.find<UserController>();
  CocktailModel? cocktail;
  RxList<CocktailModel> cocktails = <CocktailModel>[].obs;
  RxBool hasLiked = false.obs;
  late String videoUrl;
  var isLoading = false.obs;
  XFile? video;
  static StatsController get statsController => Get.find<StatsController>();
  final commentController = TextEditingController();

  Future<XFile> getVideoDownloadedFuture(String videoUrl, String jwt) async {
    return CocktailRepository.instance.downloadVideo(videoUrl, jwt);
  }

  Future<void> fetchAcceptedCocktails() async {
    isLoading.value = true;
    try {
      final jwt = UserController.instance.userCredentials!.jwt;
      cocktails.value = await CocktailRepository.instance.getAcceptedCocktails(jwt);
    } catch (e) {
      Get.snackbar("Error", "No se pudieron cargar los cócteles aceptados");
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
      Get.snackbar("Error", "No se pudieron cargar los cócteles con filtros");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfLiked(int cocktailId, int userId) async {
    try {
      hasLiked.value = await CocktailRepository.instance.hasUserLikedCocktail(cocktailId, userId);
    } catch (e) {
      Get.snackbar("Error", "No se pudo verificar si le diste like");
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
      Get.snackbar("Error", "No se pudo cambiar el like: $e");
    }
  }

  Future<void> fetchComments(int cocktailId, String jwt) async {
    print('Fetching comments for cocktail $cocktailId with jwt: $jwt');
    try {
      final data = await CocktailRepository.instance.getCommentsByCocktailId(cocktailId, jwt);
      print('Comentarios recibidos: ${data.length}');
      comments.value = data;
    } catch (e) {
      print('Error al recuperar comentarios: $e');
      Get.snackbar("Error", "No se pudieron cargar los comentarios");
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
      Get.snackbar("Error", "No se pudo enviar el comentario: $e");
    }
  }
}