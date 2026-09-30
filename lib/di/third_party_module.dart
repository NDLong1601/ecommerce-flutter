import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  FlutterSecureStorage get flutterSecureStorage =>
      const FlutterSecureStorage();

  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @preResolve
  Future<FirebaseRemoteConfig> get firebaseRemoteConfig async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    return remoteConfig;
  }

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  Logger get logger => Logger();
}
