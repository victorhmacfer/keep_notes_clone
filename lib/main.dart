import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/models/keep_clone_user.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/repository/repository.dart';
import 'package:keep_notes_clone/screens/auth_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_core/firebase_core.dart';

final flnp = FlutterLocalNotificationsPlugin();

// This reference is public to anyone who imports main.dart
// I made it deliberately global because:
//    1- All blocs need a reference to it (my convention is: screen imports main
//       and gives the repo reference to the bloc constructor, just to make the
//       dependency explicit)
GlobalRepository repo;

Size mqScreenSize;

double mqPaddingTop;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerScreenSelection>(
          create: (context) => DrawerScreenSelection(),
        ),
        ChangeNotifierProvider<NoteCardModeSelection>(
          create: (context) => NoteCardModeSelection(),
        ),
        Provider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appLightThemeData,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: _MyBehavior(),
            child: child,
          );
        },
        home: AuthStatusChecker(),
      ),
    );
  }
}

class AuthStatusChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    var mq = MediaQuery.of(context);
    mqScreenSize = mq.size;
    mqPaddingTop = mq.padding.top;

    return StreamBuilder<KeepCloneUser>(
      stream: authBloc.loggedInUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.signedOut) {
            return LoginScreen();
          }
          repo = GlobalRepository(snapshot.data.username);
          return Provider<HomeBloc>(
            create: (context) => HomeBloc(repo),
            child: PreHome(),
          );
        }
        return Container(
          color: appWhite,
          constraints: BoxConstraints.expand(),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(NoteColor.orange.getColor()),
          ),
        );
      },
    );
  }
}

class _MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
