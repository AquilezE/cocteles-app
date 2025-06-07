import 'package:cocteles_app/features/stats/model/AlcoholStats.dart';
import 'package:cocteles_app/features/stats/model/TopLikedRecipe.dart';
import 'package:cocteles_app/features/stats/model/TopUserStats.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/data/repositories/stats/StatsRepository.dart';
import 'package:cocteles_app/features/stats/model/UserStats.dart';

class StatsController extends GetxController {
  final stats = <UserStats>[].obs;
  final isLoading = false.obs;
  final alcoholStats = <AlcoholStats>[].obs;
  final topLikedRecipes = <TopLikedRecipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyStats();
    fetchAlcoholStats();
    fetchTopUsersStats();
    fetchTopLikedRecipes();
  }
var topUsers = <TopUserStats>[].obs;

Future<void> fetchTopUsersStats() async {
  try {
    isLoading.value = true;
    final data = await StatsRepository.instance.getTopUsuariosPorReceta();
    topUsers.value = data;
  } catch (e) {
    print('Error al cargar top usuarios: $e');
  } finally {
    isLoading.value = false;
  }
}


Future<void> fetchAlcoholStats() async {
  try {
    final result = await StatsRepository.instance.getAlcoholesPopulares();
    alcoholStats.assignAll(result);
  } catch (e) {
    Get.snackbar("Error", "No se pudieron cargar los alcoholes populares");
  }
}

  Future<void> fetchMonthlyStats() async {
    try {
      isLoading.value = true;
      final result = await StatsRepository.instance.getUsuariosPorMes();
      stats.assignAll(result);
      print("Se asignaron ${stats.length} estadísticas");
    } catch (e) {
      print('Error en fetchMonthlyStats: $e');
      Get.snackbar("Error", "No se pudieron cargar las estadísticas");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTopLikedRecipes() async {
    try {
      final result = await StatsRepository.instance.getRecetasMasLikeadas();
      topLikedRecipes.assignAll(result);
      print("Top recetas cargadas: ${topLikedRecipes.length}");
    } catch (e) {
      print('Error al cargar recetas más likeadas: $e');
      Get.snackbar("Error", "No se pudieron cargar las recetas con más likes");
    }
  }
}
