import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/api/api_client.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // 1. Request Permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');
        
        // 2. Initialize Local Notifications for foreground messages
        if (!kIsWeb) {
          const AndroidInitializationSettings androidSettings =
              AndroidInitializationSettings('@mipmap/ic_launcher');
          const InitializationSettings initSettings =
              InitializationSettings(android: androidSettings);
          
          await _localNotificationsPlugin.initialize(
            settings: initSettings,
          );
        }

        // 3. Get FCM Token and send to backend
        // Note: Web usually requires a vapidKey in getToken()
        String? token;
        try {
          token = await _messaging.getToken();
        } catch (e) {
          print('FCM GetToken failed: $e');
        }

        if (token != null) {
          print('FCM Token: $token');
          _updateTokenOnBackend(token);
        }

        // 4. Listen for Token Refreshes
        _messaging.onTokenRefresh.listen((newToken) {
          _updateTokenOnBackend(newToken);
        });

        // 5. Handle Foreground Messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Got a message whilst in the foreground!');
          
          if (message.notification != null) {
            _showLocalNotification(message);
          }
        });
      }
    } catch (e) {
      print('Failed to initialize notifications: $e');
    }
  }

  static void _updateTokenOnBackend(String token) async {
    try {
      await ApiClient.put('/users/me', {'fcmToken': token});
      print('Successfully updated FCM token on backend');
    } catch (e) {
      print('Failed to update FCM token: $e');
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    if (kIsWeb) return;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id: message.notification.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformDetails,
    );
  }
}

// Background Message Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
