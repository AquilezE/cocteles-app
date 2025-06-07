import 'package:cocteles_app/features/stats/model/AlcoholStats.dart';
import 'package:cocteles_app/features/stats/model/TopLikedRecipe.dart';
import 'package:cocteles_app/features/stats/model/TopUserStats.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:cocteles_app/features/stats/model/UserStats.dart';

class StatsRepository extends GetxController {
  static StatsRepository get instance => Get.find();

  Future<List<UserStats>> getUsuariosPorMes() async {
    try {
      const endpoint = 'api/v1/stats/usuarios/mensual';

      final response = await AppHttpHelper.getList(endpoint, null);
      if (response is List) {
        return response.map((item) => UserStats.fromJson(item)).toList();
      } else {
        throw Exception('Respuesta inesperada: no es una lista');
      }
    } catch (e) {
      print('Error al obtener estadísticas mensuales: $e');
      throw Exception('No se pudieron obtener las estadísticas mensuales');
    }
  }
  Future<List<TopUserStats>> getTopUsuariosPorReceta() async {
    try {
      const endpoint = 'api/v1/stats/usuarios/top-creadores';
      final response = await AppHttpHelper.getList(endpoint, null);

      if (response is List) {
        return response.map((item) => TopUserStats.fromJson(item)).toList();
      } else {
        throw Exception('Respuesta inesperada: no es una lista');
      }
    } catch (e) {
      print('Error al obtener top usuarios por receta: $e');
      throw Exception('No se pudieron obtener los top usuarios');
    }
  }

  Future<List<AlcoholStats>> getAlcoholesPopulares() async {
  try {
    const endpoint = 'api/v1/stats/licores/populares';
    final response = await AppHttpHelper.getList(endpoint, null);
    return (response as List).map((item) => AlcoholStats.fromJson(item)).toList();
  } catch (e) {
    print('Error al obtener alcoholes populares: $e');
    throw Exception('No se pudieron obtener los alcoholes populares');
  }
}

Future<List<TopLikedRecipe>> getRecetasMasLikeadas() async {
  try {
    const endpoint = 'api/v1/stats/recetas/mas-likes';
    final response = await AppHttpHelper.getList(endpoint, null);

    if (response is List) {
      return response.map((item) => TopLikedRecipe.fromJson(item)).toList();
    } else {
      throw Exception('Respuesta inesperada: no es una lista');
    }
  } catch (e) {
    print('Error al obtener recetas con más likes: $e');
    throw Exception('No se pudieron obtener las recetas con más likes');
  }
}


}


