import 'dart:convert';
import 'dart:io';
import 'package:cocteles_app/models/user_model.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:cocteles_app/features/createUser/models/UserRegistration.dart';
import 'package:http/http.dart' as http;

class UserRepository extends GetxController{

  static UserRepository get instance => Get.find();
  

  Future<UserModel> getUserDetails(String username, String? jwt) async{
    
    try{
    var endpoint = 'api/v1/usuarios/username/$username';
    final response = await AppHttpHelper.get(endpoint, jwt);
    
    return UserModel.fromJson(response);
    }catch(e){
      
      if (e is HttpException) {
        throw HttpException(
          e.statusCode,
          e.responseBody
        );
      } else {
        throw Exception('Failed to load user details');
      }
    }
  }
  Future<UserModel> updateUser(UserModel user, String? jwt) async {
  try {
    final endpoint = 'api/v1/usuarios/${user.id}';
    final response = await AppHttpHelper.put(endpoint, user.toJson(), jwt);
    return UserModel.fromJson(response);
  } catch (e) {
    if (e is HttpException) {
      throw HttpException(
        e.statusCode,
        e.responseBody
      );
    } else {
      throw Exception('Failed to update user: $e');
    }
  }
}
  
  Future<String?> uploadUserPhoto(File imageFile) async {
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/v1/upload');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        print("RESPUESTA DE IMAGEN: $respStr"); 
        final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
        final String? imageUrl = jsonResponse['imageUrl'];
        return imageUrl != null ? "${dotenv.env['BASE_URL']}$imageUrl" : null;
      } else {
        throw Exception("Error uploading image: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }

  Future<UserModel> createUser(UserRegistration user) async {
    try {
      const endpoint = 'api/v1/usuarios'; 
      final response = await AppHttpHelper.post(endpoint, user.toJson(), null);
      print("metodo de crear");
      return UserModel.fromJson(response);
    } catch (e) {
      print("error al crear el usuario");
      throw Exception('Failed to create user: $e');
    }
  }
  
}