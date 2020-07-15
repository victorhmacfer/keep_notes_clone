import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/screens/no_notes_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/archive_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/custom_widgets/drawer.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      drawer: MyDrawer(),
      body: _ArchiveBody(),
    );
  }
}

const double _bottomPadding = 56;

class _ArchiveBody extends StatelessWidget {
  Widget _noteCardBuilder(Note note) => NoteCard(note: note);

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    return SafeArea(
        top: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                floating: true,
                backgroundColor: appWhite,
                iconTheme: IconThemeData(color: appIconGrey),
                title: Text(
                  'Archive',
                  style:
                      drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                        pngIcon:
                            PngIcon(fileName: 'baseline_search_black_48.png'),
                        onTap: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                        pngIcon:
                            PngIcon(fileName: 'outline_dashboard_black_48.png'),
                        onTap: () {}),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<ArchiveViewModel>(
                    stream: noteBloc.archivedNoteListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.notes.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(bottom: _bottomPadding),
                            child: Column(
                              children:
                                  snapshot.data.notes.map(_noteCardBuilder).toList(),
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
