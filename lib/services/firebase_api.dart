import 'dart:io';

import 'package:cocteles_app/utils/http_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';


Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _storage = GetStorage();
  final _deviceIdKey = 'device_id';


  Future<void> init() async {

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('FCM permission status: ${settings.authorizationStatus}');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('FCM token refreshed: $newToken');
    });

    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
  }

  Future<String?> getDeviceId() async {
    String? deviceId = _storage.read(_deviceIdKey);

    if(deviceId != null && deviceId.isNotEmpty){
      return deviceId;
    }
    deviceId =  const Uuid().v4();
    await _storage.write(_deviceIdKey, deviceId);
    return deviceId;
  }

  Future<void> registerDevice(String jwt) async {
    final deviceID = await getDeviceId();

    final settings = await _firebaseMessaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('Push permission not granted');
      return;
    }
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {

      return;
    }

    if (fcmToken == null) {
      return;
    }

    var body ={
      'deviceId': deviceID,
      'registrationToken': fcmToken,
      'platform': Platform.operatingSystem,
    };

    await AppHttpHelper.post('api/v1/devices/', body, jwt);

  }

  Future<void> unregisterDevice(String jwt) async {
    final deviceID = await getDeviceId();

    await AppHttpHelper.delete('api/v1/devices/$deviceID', jwt);

  }
  

}