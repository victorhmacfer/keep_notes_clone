import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
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
        home: PreHome(),
      ),
    );
  }
}

class PreHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    var initSettings = InitializationSettings(
        AndroidInitializationSettings('app_icon'), IOSInitializationSettings());

    return FutureBuilder(
        future: noteBloc.initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future osn(String alarmId) async {
              var theNote = noteBloc.getNoteWithAlarmId(int.parse(alarmId));

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteSetupScreen(note: theNote)));
            }

            flnp.initialize(initSettings, onSelectNotification: osn);

            return HomeScreen();
          }
          return Container(
            color: appWhite,
            constraints: BoxConstraints.expand(),
            alignment: Alignment.center,
            child: Container(),
          );
        });
  }
}
