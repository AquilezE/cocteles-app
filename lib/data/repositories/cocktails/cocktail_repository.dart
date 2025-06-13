import 'dart:convert';
import 'dart:io';
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

  Future<List<CocktailModel>> getAcceptedCocktails(String jwt) async {
    final endpoint = 'api/v1/cocktails';
    final uri = Uri.parse('${AppHttpHelper.baseUrl}/$endpoint');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => CocktailModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener cócteles aceptados: ${response.statusCode}');
    }
  }

  Future<List<CocktailModel>> getFilteredCocktails({
    String? alcoholType,
    String? name,
    int? maxPreparationTime,
    bool? isNonAlcoholic,
    required String jwt,
  }) async {
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

    final uri = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/cocktails')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => CocktailModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener cócteles filtrados: ${response.statusCode}');
    }
  }

  Future<void> deleteCocktail(int id, String? jwt) async {
    final endpoint = 'api/v1/cocktails/$id';
    await AppHttpHelper.delete(endpoint, jwt);
  }

  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', file.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return "${AppHttpHelper.baseUrl}${data['imageUrl']}";
    } else {
      throw Exception('Error subiendo imagen: ${response.statusCode}');
    }
  }

  Future<void> uploadVideo(XFile video, String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt, videoUrl: videoUrl, videoFile: video);
    return videoService.startUpload();
  }

  Future<bool> hasUserLikedCocktail(int cocktailId, int userId) async {
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/likes/$cocktailId/hasLiked?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['hasLiked'] == true;
    } else {
      throw Exception('Error al verificar si le dio like: ${response.statusCode}');
    }
  }

  Future<void> likeCocktail(int cocktailId, String jwt) async {
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/likes/$cocktailId');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode != 201) {
      throw Exception('Error al dar like al cóctel: ${response.statusCode}');
    }
  }

  Future<void> unlikeCocktail(int cocktailId, String jwt) async {
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/likes/$cocktailId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode != 200) {
      throw Exception('Error al quitar like al cóctel: ${response.statusCode}');
    }
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