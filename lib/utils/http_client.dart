import 'dart:io';
import 'dart:convert';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cocteles_app/utils/exceptions/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class AppHttpHelper{

  static String baseUrl = dotenv.env['BASE_URL']!;

  static Map<String,String> headers = {
    'Content-Type': 'application/json'
  };

  static Future<Map<String,dynamic>> get(String endpoint, String? jwt) async{
   if (jwt != null) {
  headers['Authorization'] = 'Bearer $jwt';
}

    http.Response response;

    try{
       response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers
    );
    
    }on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 

   
    return _handleResponse(response);
  }
static Future<dynamic> getList(String endpoint, String? jwt) async {
  if (jwt != null) {
    headers['Authorization'] = 'Bearer $jwt';
  }

  http.Response response;

  try{
    response = await http.get(
    Uri.parse('$baseUrl/$endpoint'),
    headers: headers,
  );
  } on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 


  return _handleResponseDynamic(response);
}

  static Future<Map<String, dynamic>> post(String endpoint, dynamic data, String? jwt) async {
      if (jwt != null) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      http.Response response;

      try{
          response = await http.post(Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
          body: json.encode(data)
      );
      } on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(String endpoint, dynamic data, String? jwt) async {
    if (jwt != null) {
      headers['Authorization'] = 'Bearer $jwt';
    }

    http.Response response;

    try{
      response = await http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
    } on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 
  
  return _handleResponse(response);
}


  static Future<Map<String, dynamic>> put(String endpoint, dynamic data, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    http.Response response;
    try{
      response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data)
    );
    } on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 


    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    http.Response response;
    try{
      response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
      headers: headers
    );
    } on SocketException catch (_, e) {
        response = http.Response(
          json.encode({
            'message': 'No pudimos establecer una conexión con nuestro servidor, inténtalo de nuevo más tarde.',
          }),
          500
        );
      } 

    
    return _handleResponse(response);
  }

    static Future<File> getFile(String endpoint, int fileId, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers
    );

    if (response.statusCode == 200) {
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/image_$fileId.jpg';
      var file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } else {
      throw 'Failed to load image. Status code: ${response.statusCode} \n${response.body}';
    }
  }

  static Future<Map<String, dynamic>> postFile(String endpoint, String fileName, File file, String? jwt) async {
    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('POST', uri);

    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }


  static Future<Map<String, dynamic>> putFile(String endpoint, String fileName, File file, String? jwt) async {
    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('PUT', uri);

    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response? response){
    if (response!.statusCode == 204 || response.statusCode == 404){
      return <String, dynamic>{};
    }

    if(response.statusCode >= 200 && response.statusCode < 300){
      if(response.headers.containsKey('set-authorization')){
        UserController.instance.userCredentials!.jwt = response.headers['set-authorization']!;
      }
      return json.decode(response.body);
    }

    throw HttpException(
      response.statusCode,
      response.body
    );
  }

static dynamic _handleResponseDynamic(http.Response? response) {
  if (response!.statusCode == 204 || response.statusCode == 404) {
    return {}; 
  }

  if (response.statusCode >= 200 && response.statusCode < 300) {
    if (response.headers.containsKey('set-authorization')) {
      UserController.instance.userCredentials!.jwt =
          response.headers['set-authorization']!;
    }

    return json.decode(response.body);
  }

  throw HttpException(response.statusCode, response.body);
}



}