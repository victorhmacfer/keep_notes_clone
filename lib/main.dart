import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_core/firebase_core.dart';

final flnp = FlutterLocalNotificationsPlugin();

NoteRepository globalNoteRepo = NoteRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider<NoteCardModeSelection>(
          create: (context) => NoteCardModeSelection(),
        ),
        Provider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appLightThemeData,
        home: AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<String>(
      stream: authBloc.loggedInUserId,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return LoginScreen();
          }
          return Provider<HomeBloc>(
            create: (context) => HomeBloc(globalNoteRepo),
            child: PreHome(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.purple[100],
        child: Center(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(fontSize: 36),
                ),
                TextField(
                  controller: emailController,
                ),
                TextField(
                  controller: pwdController,
                ),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    var theEmail = emailController.text;
                    var thePwd = pwdController.text;

                    authBloc.login(theEmail, thePwd);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
