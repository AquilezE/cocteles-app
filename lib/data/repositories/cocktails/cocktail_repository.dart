import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/models/comment_model.dart';
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

  Future<void> addComment({
    required int cocktailId,
    required int userId,
    required String text,
    required String jwt,
  }) async {
    const endpoint = 'api/v1/comments';
    final data = {
      'cocktail_id': cocktailId,
      'user_id': userId,
      'text': text,
    };
    await AppHttpHelper.post(endpoint, data, jwt);
  } 

  Future<List<CommentModel>> getCommentsByCocktailId(int cocktailId, String jwt) async {
    final endpoint = 'api/v1/comments/cocktail/$cocktailId';
    final uri = Uri.parse('${AppHttpHelper.baseUrl}/$endpoint');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener comentarios: ${response.statusCode}');
    }
  }

  Future<XFile> downloadVideo(String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt);
    return videoService.startDownload(videoUrl);
  }

  Future<CocktailModel> getFullCocktailById(int id, String jwt) async {
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/cocktails/full/$id');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CocktailModel.fromJson(data);
    } else {
      throw Exception('Error al obtener detalle completo: ${response.statusCode}');
    }
  }

  Future<List<CocktailModel>> getPendingCocktails(String jwt) async {
    const endpoint = 'api/v1/cocktails/pending';
    final uri = Uri.parse('${AppHttpHelper.baseUrl}/$endpoint');
    
    print("URL de petición: $uri");

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => CocktailModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener cócteles pendientes: ${response.statusCode}');
    }
  }
}