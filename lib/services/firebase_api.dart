import 'dart:io';

import 'package:cocteles_app/utils/http_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  if (message.notification != null) {
    print('Notification Title: ${message.notification}');
    print('Notification Body: ${message.notification}');
  }
}

void receivedMessage(RemoteMessage remoteMessage) {
  print('recievedMessage: ');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocal = FlutterLocalNotificationsPlugin();
  final _storage = GetStorage();
  final _deviceIdKey = 'device_id';

  Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux) {
      return;
    }
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel defaultChannel =
        AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Used for normal notifications.',
      importance: Importance.high,
    );

    await _flutterLocal
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    await _flutterLocal.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
    FirebaseMessaging.onMessage.listen(receivedMessage);
  }

  Future<String?> getDeviceId() async {
    String? deviceId = _storage.read(_deviceIdKey);

    if (deviceId != null && deviceId.isNotEmpty) {
      return deviceId;
    }
    deviceId = const Uuid().v4();
    await _storage.write(_deviceIdKey, deviceId);
    return deviceId;
  }

  Future<void> registerDevice(String jwt) async {
    if (Platform.isWindows || Platform.isLinux) {
      return;
    }

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

    var body = {
      'deviceId': deviceID,
      'registrationToken': fcmToken,
      'platform': Platform.operatingSystem,
    };

    await AppHttpHelper.post('api/v1/devices/', body, jwt);
  }

  Future<void> unregisterDevice(String jwt) async {
    if (Platform.isWindows || Platform.isLinux) {
      return;
    }
    final deviceID = await getDeviceId();

    await AppHttpHelper.delete('api/v1/devices/$deviceID', jwt);
  }

  Stream<String> get tokenRefreshStream =>
      FirebaseMessaging.instance.onTokenRefresh;
}
