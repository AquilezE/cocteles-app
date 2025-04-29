import 'package:http/http.dart' as http;
import '../models/test.dart';
import 'dart:convert';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() {
    return _instance;
  }

  final String baseUrl = 'http://192.168.1.66:3000/api/v1';

  Future<Test> fetchTest() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/test'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Test.fromJson(jsonResponse);
      } else {
        throw Exception('CagoApi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Excepcion culera: $e');
    }
  }
}
