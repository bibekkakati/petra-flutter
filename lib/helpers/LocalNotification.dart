import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static LocalNotification _localNotification;

  LocalNotification._createInstance();
  factory LocalNotification() {
    if (_localNotification == null) {
      _localNotification = LocalNotification._createInstance();
      _localNotification._inititialize();
    }
    return _localNotification;
  }

  Future _onSelectNotification(String payload) async {
    _localNotification.cancelNotification();
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    _localNotification.cancelNotification();
  }

  Future<void> _inititialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate,
      {String payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'cycle',
      'Periods Notification',
      'Notify on periods day',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@drawable/ic_notification',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.schedule(
      DateTime.now().microsecond,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
