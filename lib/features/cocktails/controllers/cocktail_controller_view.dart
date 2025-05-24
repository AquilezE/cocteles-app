import 'dart:convert';
import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class CocktailDetailController extends GetxController {

  static UserController get userController => Get.find<UserController>();
  CocktailModel? cocktail;
  RxList<CocktailModel> cocktails = <CocktailModel>[].obs;
  RxBool hasLiked = false.obs;
  late String videoUrl;

  XFile? video;
  Future<XFile> getVideoDownloadedFuture(String videoUrl, String jwt) async {
    return CocktailRepository.instance.downloadVideo(videoUrl, jwt);
  }

  Future<void> fetchAcceptedCocktails() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/api/v1/cocktails'),);

      debugPrint("GET /cocktails response: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cocktails.value = data.map((e) => CocktailModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "No se pudieron cargar los cócteles aceptados");
      }
    } catch (e) {
      Get.snackbar("Error", "No fue posible conectar con el servidor: $e");
    }
  }
  Future<void> fetchFilteredCocktails({
  String? alcoholType,
  String? name,
  int? maxPreparationTime,
  bool? isNonAlcoholic,
}) async {
  try {
    final queryParams = <String, String>{};

    if (alcoholType != null && alcoholType.isNotEmpty) {
      queryParams['alcoholType'] = alcoholType;
    }
    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }
    if (maxPreparationTime != null) {
      queryParams['maxPreparationTime'] = maxPreparationTime.toString();
    }
    if (isNonAlcoholic != null) {
      queryParams['isNonAlcoholic'] = isNonAlcoholic.toString();
    }

    final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/v1/cocktails')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    debugPrint("GET /cocktails with filters response: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      cocktails.value = data.map((e) => CocktailModel.fromJson(e)).toList();
    } else {
      Get.snackbar("Error", "No se pudieron cargar los cócteles con filtros");
    }
  } catch (e) {
    Get.snackbar("Error", "Fallo de conexión: $e");
  }
}

  Future<void> checkIfLiked(int cocktailId, int userId) async {
    final url = '${dotenv.env['BASE_URL']}/api/v1/likes/$cocktailId/hasLiked?userId=$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      hasLiked.value = json.decode(response.body)['hasLiked'] == true;
    }
  }

  Future<void> toggleLike(int cocktailId, String jwt) async {
    final headers = {'Authorization': 'Bearer $jwt'};
    final url = '${dotenv.env['BASE_URL']}/api/v1/likes/$cocktailId';

    if (hasLiked.value) {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        hasLiked.value = false;
        cocktail?.likes = (cocktail?.likes ?? 1) - 1;
      }
    } else {
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 201) {
        hasLiked.value = true;
        cocktail?.likes = (cocktail?.likes ?? 0) + 1;
      }
    } 
    cocktails.refresh();
  }



}