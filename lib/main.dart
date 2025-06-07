import 'dart:io';

import 'package:cocteles_app/app.dart';
import 'package:cocteles_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cocteles_app/data/repositories/stats/StatsRepository.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';
import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/stats/controllers/StatsController.dart';
import 'package:cocteles_app/services/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:cocteles_app/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cocteles_app/features/stats/screens/UserStatsPage.dart';
final flutterLocal = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const windowsSettings = WindowsInitializationSettings(
      appName: 'Cocteles',
      appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
      guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb');

  await flutterLocal.initialize(
    const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
      windows: windowsSettings,
    ),
  );

  Get.put(AuthenticationRepository());
  Get.put(UserRepository());
  Get.put(CocktailRepository());
  Get.put(StatsRepository());
  Get.put(StatsController());


  if (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    MediaKit.ensureInitialized();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    runApp(const App());
  }
}
