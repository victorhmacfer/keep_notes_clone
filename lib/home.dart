import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/models/pinned_status_note_splitter.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/screens/no_notes_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'package:keep_notes_clone/models/note.dart';

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
      bottomNavigationBar: MyNotchedBottomAppBar(),
      drawer: MyDrawer(),
      body: _HomeBody(),
    );
  }
}

Widget _noteCardBuilder(Note note) => NoteCard(note: note);

class _HomeBody extends StatelessWidget {
  static const double _bottomPadding = 56;

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
              child: StreamBuilder<PinnedStatusNoteSplitter>(
                stream: noteBloc.pinnedUnpinnedNoteListsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var pinnedNotes = snapshot.data.pinned;
                    var unpinnedNotes = snapshot.data.unpinned;

                    if (pinnedNotes.isNotEmpty || unpinnedNotes.isNotEmpty) {
                      if (pinnedNotes.isEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: _bottomPadding),
                          child: Column(
                            children:
                                unpinnedNotes.map(_noteCardBuilder).toList(),
                          ),
                        );
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: _bottomPadding),
                        child: Column(
                          children: <Widget>[
                            _SectionTitle('PINNED'),
                            Column(
                              children:
                                  pinnedNotes.map(_noteCardBuilder).toList(),
                            ),
                            _OthersColumn(unpinnedNotes),
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
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
}

class _OthersColumn extends StatelessWidget {
  final List<Note> unpinnedNotesList;

  _OthersColumn(this.unpinnedNotesList);

  @override
  Widget build(BuildContext context) {
    if (unpinnedNotesList.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        _SectionTitle('OTHERS'),
        Column(
          children: unpinnedNotesList.map(_noteCardBuilder).toList(),
        ),
      ],
    );
  }
}
