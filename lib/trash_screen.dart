import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/no_notes_screen.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/drawer.dart';

class TrashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      drawer: MyDrawer(),
      body: TrashBody(),
    );
  }
}

const double _bottomPadding = 56;

class TrashBody extends StatelessWidget {
  Widget _noteCardBuilder(Note note) => NoteCard(note: note);

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    return SafeArea(
        child: Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: appWhite,
            iconTheme: IconThemeData(color: appIconGrey),
            title: Text(
              'Trash',
              style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: PngIconButton(
                    pngIcon: PngIcon(fileName: 'baseline_search_black_48.png'),
                    onTap: () {}),
              ),
              
            ],
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<Note>>(
                stream: noteBloc.deletedNoteListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isNotEmpty) {
                      return Container(
                        margin: EdgeInsets.only(bottom: _bottomPadding),
                        child: Column(
                          children:
                              snapshot.data.map(_noteCardBuilder).toList(),
                        ),
                      );
                    }
                    return NoNotesScreen();
                  }
                  return NoNotesScreen();
                }),
          ),
        ],
      ),
    ));
  }
}
