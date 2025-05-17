import 'dart:convert';
import 'dart:io';
import 'package:cocteles_app/models/user_model.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:cocteles_app/features/createUser/models/UserRegistration.dart';

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