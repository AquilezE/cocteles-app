import 'dart:convert';

class HttpException implements Exception {
  final int statusCode;
  final String responseBody;

  HttpException(this.statusCode, this.responseBody);

  String get message {
    try {
      final decoded = json.decode(responseBody);
      if (decoded is Map) {
        if (decoded.containsKey('message')) {
          return decoded['message'];
        } else if (decoded.containsKey('mensaje')) {
          return decoded['mensaje'];
        }
      }
    } catch (_) {}
    return responseBody;
  }

  @override
  String toString() {
    return message;
  }
}