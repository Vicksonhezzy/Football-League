import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String topicName = 'all';
String _serverKey = '';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  CollectionReference<Map<String, dynamic>> apiCollection =
      firestore.collection('apiKey');

  NotificationService() {
    getKeys();
  }

  getKeys() async {
    QuerySnapshot<Map<String, dynamic>> value =
        await apiCollection.limit(1).get();
    if (value.docs.isNotEmpty) {
      Map<String, dynamic> keys = value.docs.first.data();
      _serverKey = keys['private_key'];
      print('keys set');
    }
  }

  static Future<void> sendNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };

    final Map<String, dynamic> payload = {
      'notification': notification,
      'data': data,
      'to': '/topics/$topicName',
    };

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    // print(payload);

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  }

  static Future<void> subscribeToTopic({String topic = topicName}) async {
    await messaging.subscribeToTopic(topic);
  }
}

class MyNoitifications {
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'sbc_league',
      'SBC League',
      description: 'SBC League',
      importance: Importance.high,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("Initialized notification");
  }

  static Future<void> showNotification(
      int id, String title, String body, Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sbc_league',
      'SBC League',
      channelDescription: 'SBC League',
      groupKey: id.toString(),
      tag: id.toString(),
      setAsGroupSummary: true,
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: data.toString(),
    );
  }
}
