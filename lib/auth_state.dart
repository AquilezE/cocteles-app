import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  String? jwt;

  bool get isLoggedIn => jwt != null;

  /// TODO: replace this stub with your real REST call
  Future<bool> login(String user, String pass) async {
    // fake delay / pretend we hit your backend…
    await Future.delayed(Duration(seconds: 1));
    // on success:
    jwt = 'FAKE_JWT_TOKEN';
    notifyListeners();
    return true;
  }

  void logout() {
    jwt = null;
    notifyListeners();
  }
}
