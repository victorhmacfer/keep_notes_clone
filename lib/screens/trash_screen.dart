import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/trash_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/custom_widgets/drawer.dart';

class TrashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      drawer: MyDrawer(),
      body: _TrashBody(),
    );
  }
}

const double _bottomPadding = 56;

class _TrashBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var notifier = Provider.of<NoteCardModeSelection>(context);

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
                  'Trash',
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
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<TrashViewModel>(
                    stream: noteBloc.trashViewModelStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.notes.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(bottom: _bottomPadding),
                            child: OptionalSection(
                              mode: notifier.mode,
                              notes: snapshot.data.notes,
                              noSpacer: true,
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
