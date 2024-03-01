import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  static Future<void> initialize() async {
    // Initialisez ici les paramètres de vos notifications
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }
}
