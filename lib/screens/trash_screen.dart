import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/trash_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/custom_widgets/drawer.dart';

class TrashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MultiNoteSelection>(
      create: (context) => MultiNoteSelection(),
      child: Scaffold(
        backgroundColor: appWhite,
        drawer: MyDrawer(),
        body: _TrashBody(),
      ),
    );
  }
}

const double _bottomPadding = 56;

enum TrashMenuAction { emptyTrash }

class _TrashBody extends StatelessWidget {
  List<Note> _trashNotes = [];

  Widget _sliverAppBar(
      {@required NoteTrackingBloc noteBloc, @required BuildContext context}) {
    return SliverAppBar(
      brightness: Brightness.light,
      floating: true,
      backgroundColor: appWhite,
      iconTheme: IconThemeData(color: appIconGrey),
      title: Text(
        'Trash',
        style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
      ),
      actions: <Widget>[
        PopupMenuButton<TrashMenuAction>(
          onSelected: (action) {
            if (action == TrashMenuAction.emptyTrash) {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Empty Trash?',
                        style: cardTitleStyle,
                      ),
                      content: Text(
                          'All notes in Trash will be permanently deleted.'),
                      titlePadding: EdgeInsets.only(top: 24, left: 24),
                      contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 8),
                      actionsPadding: EdgeInsets.zero,
                      buttonPadding: EdgeInsets.only(right: 16),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                              Text('Cancel', style: dialogFlatButtonTextStyle),
                        ),
                        FlatButton(
                          onPressed: () {
                            noteBloc.emptyTrash(_trashNotes);
                            Navigator.pop(context);
                          },
                          child: Text('Empty Trash',
                              style: dialogFlatButtonTextStyle),
                        ),
                      ],
                    );
                  });
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => <PopupMenuEntry<TrashMenuAction>>[
            PopupMenuItem<TrashMenuAction>(
              value: TrashMenuAction.emptyTrash,
              child: Text('Empty Trash'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var notifier = Provider.of<NoteCardModeSelection>(context);

    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    return SafeArea(
        top: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              (multiNoteSelection.inactive)
                  ? _sliverAppBar(noteBloc: noteBloc, context: context)
                  : SliverMultiNoteSelectionAppBar(
                      notifier: multiNoteSelection,
                      noteBloc: noteBloc,
                    ),
              SliverToBoxAdapter(
                child: StreamBuilder<TrashViewModel>(
                    stream: noteBloc.trashViewModelStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _trashNotes = snapshot.data.notes;
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
