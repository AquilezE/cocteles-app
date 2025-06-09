import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:get/get.dart';

class CocktailApprovalController extends GetxController {
  RxList<CocktailModel> pendingCocktails = <CocktailModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchPendingCocktails(String jwt) async {
    try {
      isLoading.value = true;
      final cocktails = await CocktailRepository.instance.getPendingCocktails(jwt);
      pendingCocktails.assignAll(cocktails);
    } catch (e) {
      Get.snackbar("Error", "No se pudieron cargar los cócteles pendientes");
    } finally {
      isLoading.value = false;
    }
  }
}