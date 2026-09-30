import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Handler for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final logger = Logger();
  logger.i('Background message received: ${message.messageId}');
  logger.i('Title: ${message.notification?.title}');
  logger.i('Body: ${message.notification?.body}');
  logger.i('Data: ${message.data}');
}

@LazySingleton()
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final Logger _logger;

  NotificationService(
    this._firebaseMessaging,
    this._localNotifications,
    this._logger,
  );

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request notification permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Configure FCM
      await _configureFCM();

      // Get FCM token
      final token = await getFCMToken();
      _logger.i('FCM Token: $token');

      // Listen to token refresh
      _listenToTokenRefresh();

      // Setup message handlers
      _setupMessageHandlers();

      _logger.i('Notification service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize notification service: $e');
      rethrow;
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      _logger.i(
        'Notification permission status: ${settings.authorizationStatus}',
      );
      return isGranted;
    } catch (e) {
      _logger.e('Failed to request permissions: $e');
      return false;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Configure FCM settings
  Future<void> _configureFCM() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      _logger.i('FCM Token retrieved: $token');

      /// send token to backend
      return token;
    } catch (e) {
      _logger.e('Failed to get FCM token: $e');
      return null;
    }
  }

  /// Listen to token refresh
  void _listenToTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _logger.i('FCM Token refreshed: $token');

      /// send token to backend
    });
  }

  /// Setup message handlers for different app states
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is in background but opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle messages when app is terminated and opened
    _handleInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.i('Foreground message received: ${message.messageId}');
    _logger.i('Title: ${message.notification?.title}');
    _logger.i('Body: ${message.notification?.body}');
    _logger.i('Data: ${message.data}');

    // Show local notification when app is in foreground
    await _showLocalNotification(message);
  }

  /// Handle message when app is opened from background
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    _logger.i('Message opened app from background: ${message.messageId}');
    _logger.i('Data: ${message.data}');

    // Navigate to specific screen based on notification data
    await _handleNotificationNavigation(message.data);
  }

  /// Handle initial message when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      _logger.i('App opened from terminated state: ${message.messageId}');
      _logger.i('Data: ${message.data}');

      // Navigate to specific screen based on notification data
      await _handleNotificationNavigation(message.data);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      _logger.e('Failed to show local notification: $e');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    _logger.i('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _handleNotificationNavigation(data);
    }
  }

  /// Handle notification navigation based on data
  Future<void> _handleNotificationNavigation(Map<String, dynamic> data) async {
    _logger.i('Handling notification navigation with data: $data');

    // TODO: Implement navigation logic based on notification data
    // Example:
    // final type = data['type'] as String?;
    // final id = data['id'] as String?;
    //
    // switch (type) {
    //   case 'order':
    //     // Navigate to order details screen
    //     break;
    //   case 'product':
    //     // Navigate to product details screen
    //     break;
    //   default:
    //     // Navigate to home or notifications screen
    //     break;
    // }
  }
}
