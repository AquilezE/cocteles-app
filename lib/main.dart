import 'package:cocteles_app/app.dart';
import 'package:cocteles_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

Future<void> main() async {

  await dotenv.load(fileName: ".env");

  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(AuthenticationRepository());
  Get.put(UserRepository());
  
  runApp(const App());
}


