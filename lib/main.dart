import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:sbc_league/app.dart';
import 'package:sbc_league/controllers/authentication_controller.dart';
import 'package:sbc_league/core/utils/firebase_utils.dart';
import 'package:sbc_league/core/utils/notification_service.dart';
import 'package:sbc_league/core/utils/pref_utils.dart';
import 'package:sbc_league/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('STARTED');
  MyNoitifications.showNotification(
    message.notification?.hashCode ?? 0,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    message.data,
  );
}

late final FirebaseApp app;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  // auth = FirebaseAuth.instanceFor(app: app);

  await PrefUtils().init();

  FirebaseUtils();

  Get.put(AuthController());

  NotificationService();

  await MyNoitifications.initialize();

  // Handle incoming messages when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    MyNoitifications.showNotification(
      message.notification?.hashCode ?? message.data['id'],
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      message.data,
    );
  });

  // Handle notification clicks when the app is in the background or terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
