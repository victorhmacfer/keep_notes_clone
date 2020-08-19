import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/archive_bloc.dart';
import 'package:keep_notes_clone/blocs/drawer_bloc.dart';
import 'package:keep_notes_clone/blocs/edit_labels_bloc.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/blocs/note_labeling_bloc.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/blocs/reminders_bloc.dart';
import 'package:keep_notes_clone/blocs/search_bloc.dart';
import 'package:keep_notes_clone/blocs/trash_bloc.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flnp = FlutterLocalNotificationsPlugin();

NoteRepository globalNoteRepo = NoteRepository();

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
        Provider<SearchBloc>(
          create: (context) => SearchBloc(globalNoteRepo),
        ),
        Provider<NoteSetupBloc>(
          create: (context) => NoteSetupBloc(globalNoteRepo),
        ),
        Provider<NoteLabelingBloc>(
          create: (context) => NoteLabelingBloc(globalNoteRepo),
        ),
        Provider<DrawerBloc>(
          create: (context) => DrawerBloc(globalNoteRepo),
        ),
        Provider<RemindersBloc>(
          create: (context) => RemindersBloc(globalNoteRepo),
        ),
        Provider<ArchiveBloc>(
          create: (context) => ArchiveBloc(globalNoteRepo),
        ),
        Provider<TrashBloc>(
          create: (context) => TrashBloc(globalNoteRepo),
        ),
        Provider<EditLabelsBloc>(
          create: (context) => EditLabelsBloc(globalNoteRepo),
        ),
        ChangeNotifierProvider<DrawerScreenSelection>(
          create: (context) => DrawerScreenSelection(),
        ),
        ChangeNotifierProvider<NoteCardModeSelection>(
          create: (context) => NoteCardModeSelection(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appLightThemeData,
        home: Provider<HomeBloc>(
          create: (context) => HomeBloc(globalNoteRepo),
          child: PreHome(),
        ),
      ),
    );
  }
}
