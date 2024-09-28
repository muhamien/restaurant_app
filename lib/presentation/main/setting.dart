import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/app_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';

class SettingScreen extends StatefulWidget{
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  @override
  void initState() {
    super.initState();
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
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider<SchedulingProvider>(
                        create: (_) => SchedulingProvider(),
                      ),
                      ChangeNotifierProvider<AppProvider>(
                        create: (_) => AppProvider(),
                      ),
                    ],
                    child: Consumer2<SchedulingProvider, AppProvider>(
                      builder: (context, schedulingProvider, appProvider, _) {
                        return Switch.adaptive(
                          value: appProvider.isNotificationScheduled,
                          onChanged: (value) async {
                            appProvider.setNotificationSchedule(value);
                            schedulingProvider.scheduledNews(value);
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