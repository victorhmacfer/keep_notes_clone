import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flnp = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        Provider<NoteTrackingBloc>(
            create: (context) => NoteTrackingBloc(),
            dispose: (context, theBloc) => theBloc.dispose()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appLightThemeData,
        home: HomeScreen(),
      ),
    );
  }
}

// class Blabla extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     return FutureBuilder<NotificationAppLaunchDetails>(
//       future: flnp.getNotificationAppLaunchDetails(),
//       builder: (context, snapshot) {
//         bool launchedByNotif;
//         if (snapshot.connectionState == ConnectionState.done) {
//           launchedByNotif = snapshot.data.didNotificationLaunchApp;
//         } else {
//           return CircularProgressIndicator();
//         }

//         if (launchedByNotif) {
//           print('APP LAUNCHED BY NOTIF');
//           return MaterialApp(
//             title: 'Flutter Demo',
//             theme: appLightThemeData,
//             home: HomeScreen(),
//           );
//         }

//         print('APP NOOOOOOT  LAUNCHED BY NOTIF');

//         return MaterialApp(
//           title: 'Flutter Demo',
//           theme: appLightThemeData,
//           home: HomeScreen(),
//         );
//       },
//     );
//   }
// }

// class PreHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     var initializationSettings = InitializationSettings(
//         AndroidInitializationSettings('app_icon'), IOSInitializationSettings());

//     flnp.initialize(initializationSettings,
//         onSelectNotification: (payload) async {
//       // pretending payload is id 1..
//       // ignoring noteRepo for now

//       var theNote = Note(
//           id: 1, title: 'xablau vai funcionar', lastEdited: DateTime.now());

//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => NoteSetupScreen(
//                     note: theNote,
//                   )));
//     });

//     return Container(

//     );
//   }
// }
