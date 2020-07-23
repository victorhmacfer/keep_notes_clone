import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future selectNotification(String payload) async {
  await Future.delayed(Duration(seconds: 2));
  print('selecionei a notif');
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettings = InitializationSettings(
      AndroidInitializationSettings('app_icon'), IOSInitializationSettings());

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerScreenSelection>(
          create: (context) => DrawerScreenSelection(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appLightThemeData,
        home: HomeScreen(),
      ),
    );
  }
}
