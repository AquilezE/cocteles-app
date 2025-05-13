import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:get/get.dart';

class CocktailRepository extends GetxController {
  static CocktailRepository get instance => Get.find();

  Future<void> createCocktail(CocktailModel data, String? jwt) async {
    const endpoint = 'api/v1/cocktails';
    await AppHttpHelper.post(endpoint, data.toJson(), jwt);
  }

  Future<CocktailModel> getCocktailById(int id, String? jwt) async {
    final endpoint = 'api/v1/cocktails/$id';
    final json = await AppHttpHelper.get(endpoint, jwt);
    return CocktailModel.fromJson(json);
  }

  Future<void> deleteCocktail(int id, String? jwt) async {
    final endpoint = 'api/v1/cocktails/$id';
    await AppHttpHelper.delete(endpoint, jwt);
  }
}
