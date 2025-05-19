import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:cocteles_app/models/cocktail_model.dart';

class CocktailDetailController extends GetxController {
  CocktailModel? cocktail;
  RxList<CocktailModel> cocktails = <CocktailModel>[].obs;

  Future<void> fetchAcceptedCocktails() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.100.41:3000/api/v1/cocktails'),);

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
}