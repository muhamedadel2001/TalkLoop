import 'package:chatapp/core/utilits/dio.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      if (value != null) {
        HomeCubit.me.pushToken = value;

      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {


      if (message.notification != null) {
      }
    });
  }

  static Future<void> sendNotification(
      ChatUserModel chatUserModel, String msg) async {
    try {
      Response response = await MyDio.postData(endPoint: 'send', data: {
        "to": chatUserModel.pushToken,
        "notification": {
          "title": chatUserModel.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "someData": "User Id:${chatUserModel.id}",
        },
      });

      return response.data;
    } catch (e) {
      if (kDebugMode) {
      }
    }
  }

  static  inatializeNotification() async {
    await FlutterNotificationChannel.registerNotificationChannel(
      description: 'for showing message notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
    );
  }
}
