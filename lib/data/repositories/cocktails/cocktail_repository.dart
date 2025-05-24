import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cocteles_app/data/services/video_service.dart';
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

    
  Future<void> uploadVideo(XFile video, String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt, videoUrl: videoUrl, videoFile: video);
    return videoService.startUpload();
  }


  Future<XFile> downloadVideo(String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt);
    return videoService.startDownload(videoUrl);
  }
}
