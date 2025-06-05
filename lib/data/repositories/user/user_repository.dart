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
  
Future<void> sendVerificationEmail(String email) async {
  try {
    final endpoint = 'api/v1/verification/send';
    final response = await AppHttpHelper.post(endpoint, {'email': email}, null);
    print('Correo de verificación enviado: $response');
  } catch (e) {
    print("Error al enviar verificación: $e");
    throw Exception('Error al enviar verificación');
  }
}

Future<void> verifyEmailCode(String email, String code) async {
  try {
    final endpoint = 'api/v1/verification/verify';
    final response = await AppHttpHelper.post(endpoint, {
      'email': email,
      'code': code,
    }, null);
    print('Código verificado correctamente: $response');
  } catch (e) {
    print("Código incorrecto o expirado: $e");
    throw Exception('Código incorrecto o expirado');
  }
}
Future<UserModel> createUser(UserRegistration user) async {
  try {
    const endpoint = 'api/v1/usuarios';
    final response = await AppHttpHelper.post(endpoint, user.toJson(), null);
    print("Usuario creado: $response");
    return UserModel.fromJson(response);
  } catch (e, stacktrace) {
    print("Error al crear el usuario: ");
    print(stacktrace);
    throw Exception('Failed to create user: ');
  }
}

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
      throw Exception('Failed to update user');
    }
  }
}
Future<bool> changePassword({
  required int userId,
  required String currentPassword,
  required String newPassword,
  required String? jwt,
}) async {
  try {
    final endpoint = 'api/v1/usuarios/$userId/change-password';

    final data = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    final response = await AppHttpHelper.patch(endpoint, data, jwt);

    if (response is Map<String, dynamic>) {
      if (response['message'] == "Contraseña actualizada correctamente") {
        return true; // Éxito
      } else {
        throw Exception(response['message'] ?? 'Error al cambiar contraseña');
      }
    } else {
      throw Exception('Respuesta inesperada del servidor');
    }
  } catch (e) {
    if (e is HttpException) {
      throw HttpException(e.statusCode, e.responseBody);
    } else {
      throw Exception('Error al cambiar contraseña');
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
        throw Exception("Error uploading image");
      }
    } catch (e) {
      throw Exception("Upload failed");
    }
  }

  
  
}