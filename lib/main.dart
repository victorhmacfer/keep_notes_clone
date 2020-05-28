import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Provider<NoteTrackingBloc>(
      create: (context) => NoteTrackingBloc(),
      dispose: (context, theBloc) => theBloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: appLightThemeData,
        home: HomeScreen(),
      ),
    );
  }
}
