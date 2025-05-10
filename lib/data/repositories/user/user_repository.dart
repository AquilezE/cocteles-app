import 'dart:convert';
import 'dart:io';

import 'package:cocteles_app/models/user_model.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:get/get.dart';

import 'package:cocteles_app/utils/http_client.dart';

class UserRepository extends GetxController{

  static UserRepository get instance => Get.find();

  Future<UserModel> getUserDetails(String username, String? jwt) async{
    
    try{
    //FALTA PONER UN PUTA ENDPOINT AQUI
    var endpoint = 'api/v1/user/$username';
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


}