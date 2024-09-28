import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget{
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>{
  static const String scheduleNotificationPref = 'scheduleNotification';

  final NotificationHelper _notificationHelper = NotificationHelper();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  bool _isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    _loadSettingPrefs();
  }

  void _settingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(scheduleNotificationPref, _isNotificationScheduled);
  }

  void _loadSettingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationScheduled = prefs.getBool(scheduleNotificationPref) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 38, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Schedule Notification", style: TextStyle(fontSize: 18.0),),
                  ChangeNotifierProvider<SchedulingProvider>(
                    create: (_) => SchedulingProvider(),
                    child: Consumer<SchedulingProvider>(
                      builder: (context, scheduled, _) {
                        return Switch.adaptive(
                          value: _isNotificationScheduled,
                          onChanged: (value) async {
                            scheduled.scheduledNews(value);
                            setState(() {
                              _settingPrefs();
                              _isNotificationScheduled = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
      )),
    );
  }
}