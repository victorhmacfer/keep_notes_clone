import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        Provider<NoteTrackingBloc>(
          create: (context) => NoteTrackingBloc(),
          dispose: (context, theBloc) => theBloc.dispose(),
        ),
        ChangeNotifierProvider<DrawerScreenSelection>(
          create: (context) => DrawerScreenSelection(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: appLightThemeData,
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
