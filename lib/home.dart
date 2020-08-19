import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/main.dart';

class PreHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);

    double constrainedTextSF =
        mediaQueryData.textScaleFactor.clamp(0.75, 1.3).toDouble();

    var homeBloc = Provider.of<HomeBloc>(context);

    var initSettings = InitializationSettings(
        AndroidInitializationSettings('app_icon'), IOSInitializationSettings());

    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: constrainedTextSF),
      child: FutureBuilder(
          future: homeBloc.initialized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Future osn(String alarmId) async {
                var theNote = homeBloc.getNoteWithAlarmId(int.parse(alarmId));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteSetupScreen(note: theNote)));
              }

              flnp.initialize(initSettings, onSelectNotification: osn);

              return HomeScreen();
            }
            return _WhiteScreen();
          }),
    );
  }
}

class _WhiteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhite,
      constraints: BoxConstraints.expand(),
      alignment: Alignment.center,
      child: Container(),
    );
  }
}

const double _bottomPadding = 56;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return ChangeNotifierProvider<MultiNoteSelection>(
      create: (context) => MultiNoteSelection(),
      child: Scaffold(
        backgroundColor: appWhite,
        extendBody: true, // making the bottom bar notch transparent
        floatingActionButton: MyCustomFab(),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyNotchedBottomAppBar(),
        drawer: MyDrawer(),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);
    var homeBloc = Provider.of<HomeBloc>(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            (multiNoteSelection.inactive)
                ? SearchAppBar()
                : SliverMultiNoteSelectionAppBar(
                    notifier: multiNoteSelection,
                    noteChangerBloc: homeBloc,
                  ),
            SliverToBoxAdapter(
              child: _StreamBuilderBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeBloc = Provider.of<HomeBloc>(context);

    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<HomeViewModel>(
      stream: homeBloc.homeViewModelStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var pinnedNotes = snapshot.data.pinned;
          var unpinnedNotes = snapshot.data.unpinned;
          var hasAnyNote = snapshot.data.all.isNotEmpty;

          if (hasAnyNote) {
            if (pinnedNotes.isEmpty) {
              return Container(
                margin: EdgeInsets.only(bottom: _bottomPadding),
                child: (modeNotifier.mode == NoteCardMode.extended)
                    ? ExtendedModeList(unpinnedNotes)
                    : SmallModeGrid(unpinnedNotes),
              );
            }

            return Container(
              margin: EdgeInsets.only(bottom: _bottomPadding),
              child: Column(
                children: <Widget>[
                  CardTypeSectionTitle('PINNED'),
                  (modeNotifier.mode == NoteCardMode.extended)
                      ? ExtendedModeList(pinnedNotes)
                      : SmallModeGrid(pinnedNotes),
                  OptionalSection(
                    title: 'OTHERS',
                    mode: modeNotifier.mode,
                    notes: unpinnedNotes,
                  ),
                ],
              ),
            );
          }
          return NoNotesScreen();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
