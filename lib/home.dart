import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';

import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'models/note.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: appWhite,
      extendBody: true, // making the bottom bar notch transparent
      floatingActionButton: MyCustomFab(),
      floatingActionButtonLocation: MyCustomFabLocation(),
      bottomNavigationBar: MyBottomAppBar(),
      drawer: MyDrawer(),
      body: HomeBody(),
    );
  }
}

const double _bottomPadding = 56;

class HomeBody extends StatelessWidget {
  Widget _noteCardBuilder(Note note) {
    return NoteCard(note: note);
    // return NoteCard(
    //   title: note.title,
    //   text: note.text,
    //   color: NoteColor.getNoteColorFromIndex(note.colorIndex),
    // );
  }

  Widget _sectionTitle(String title) {
    return Container(
      color: appWhite,
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: drawerLabelsEditStyle.copyWith(fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }

  Widget _othersColumn(List<Note> unpinnedNotesList) {
    if (unpinnedNotesList.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        _sectionTitle('OTHERS'),
        Column(
          children: unpinnedNotesList.map(_noteCardBuilder).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    return SafeArea(
      // ignoring the bottom safearea is necessary for "extendBody" to work
      bottom: false,
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SearchAppBar(),
            SliverToBoxAdapter(
              child: StreamBuilder<List<List<Note>>>(
                stream: noteBloc.pinnedUnpinnedNoteListsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var pinnedNotesList = snapshot.data[0];
                    var unpinnedNotesList = snapshot.data[1];

                    if (pinnedNotesList.isNotEmpty ||
                        unpinnedNotesList.isNotEmpty) {

                      if (pinnedNotesList.isEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: _bottomPadding),
                          child: Column(
                            children:
                                snapshot.data[1].map(_noteCardBuilder).toList(),
                          ),
                        );
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: _bottomPadding),
                        child: Column(
                          children: <Widget>[
                            _sectionTitle('PINNED'),
                            Column(
                              children: pinnedNotesList
                                  .map(_noteCardBuilder)
                                  .toList(),
                            ),
                            _othersColumn(unpinnedNotesList),
                          ],
                        ),
                      );
                    }
                    return NoNotesScreen();
                  }

                  return NoNotesScreen();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoNotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/icons/keep-logo.png',
            height: 100,
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Notes you add appear here',
            style: cardSmallTextStyle,
          ),
        ],
      ),
    );
  }
}
