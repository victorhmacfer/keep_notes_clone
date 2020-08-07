import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/archive_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/custom_widgets/drawer.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MultiNoteSelection>(
      create: (context) => MultiNoteSelection(),
      child: Scaffold(
        backgroundColor: appWhite,
        drawer: MyDrawer(),
        body: _ArchiveBody(),
      ),
    );
  }
}

const double _bottomPadding = 56;

class _ArchiveBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    return SafeArea(
        top: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              (multiNoteSelection.inactive)
                  ? _SliverAppBar()
                  : MultiNoteSelectionAppBar(multiNoteSelection),
              SliverToBoxAdapter(
                child: _StreamBuilderBody(),
              ),
            ],
          ),
        ));
  }
}

class _SliverAppBar extends StatelessWidget {
  Widget _selectNoteCardModeButton(NoteCardModeSelection notifier) {
    if (notifier.mode == NoteCardMode.extended) {
      return PngIconButton(
          backgroundColor: appWhite,
          padding: EdgeInsets.symmetric(horizontal: 8),
          pngIcon: PngIcon(
            fileName: 'outline_dashboard_black_48.png',
          ),
          onTap: () {
            notifier.switchTo(NoteCardMode.small);
          });
    }
    return PngIconButton(
        backgroundColor: appWhite,
        padding: EdgeInsets.symmetric(horizontal: 8),
        pngIcon: PngIcon(
          fileName: 'outline_view_agenda_black_48.png',
        ),
        onTap: () {
          notifier.switchTo(NoteCardMode.extended);
        });
  }

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteCardModeSelection>(context);

    return SliverAppBar(
      brightness: Brightness.light,
      floating: true,
      backgroundColor: appWhite,
      iconTheme: IconThemeData(color: appIconGrey),
      title: Text(
        'Archive',
        style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              backgroundColor: appWhite,
              pngIcon: PngIcon(fileName: 'baseline_search_black_48.png'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteSearchScreen()));
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: _selectNoteCardModeButton(notifier),
        ),
      ],
    );
  }
}

class _StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<ArchiveViewModel>(
      stream: noteBloc.archiveViewModelStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var hasAnyNote = snapshot.data.notes.isNotEmpty;

          if (hasAnyNote) {
            return Container(
              margin: EdgeInsets.only(bottom: _bottomPadding),
              child: (modeNotifier.mode == NoteCardMode.extended)
                  ? ExtendedModeList(snapshot.data.notes)
                  : SmallModeGrid(snapshot.data.notes),
            );
          }
          return NoNotesScreen();
        }
        return NoNotesScreen();
      },
    );
  }
}
