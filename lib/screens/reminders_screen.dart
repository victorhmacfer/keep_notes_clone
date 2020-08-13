import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/reminders_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/reminders_view_model.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MultiNoteSelection>(
      create: (context) => MultiNoteSelection(),
      child: Scaffold(
        backgroundColor: appWhite,
        extendBody: true,
        floatingActionButton: MyCustomFab(),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyNotchedBottomAppBar(),
        drawer: MyDrawer(),
        body: _Body(),
      ),
    );
  }
}

const double _bottomPadding = 56;

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);
    var remindersBloc = Provider.of<RemindersBloc>(context);

    return SafeArea(
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              (multiNoteSelection.inactive)
                  ? _RemindersAppBar()
                  : SliverMultiNoteSelectionAppBar(
                      notifier: multiNoteSelection,
                      noteChangerBloc: remindersBloc,
                    ),
              SliverToBoxAdapter(
                child: _StreamBuilderBody(),
              ),
            ],
          ),
        ));
  }
}

class _RemindersAppBar extends StatelessWidget {
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
      floating: true,
      backgroundColor: appWhite,
      iconTheme: IconThemeData(color: appIconGrey),
      title: Text(
        'Reminders',
        style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
              backgroundColor: appWhite,
              padding: EdgeInsets.symmetric(horizontal: 8),
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
    var remindersBloc = Provider.of<RemindersBloc>(context);
    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<RemindersViewModel>(
        stream: remindersBloc.remindersViewModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var firedReminderNotes = snapshot.data.fired;
            var upcomingReminderNotes = snapshot.data.upcoming;

            var hasAnyNote = firedReminderNotes.isNotEmpty ||
                upcomingReminderNotes.isNotEmpty;

            if (hasAnyNote) {
              return Container(
                margin: EdgeInsets.only(bottom: _bottomPadding),
                child: Column(
                  children: <Widget>[
                    OptionalSection(
                      title: 'FIRED',
                      mode: modeNotifier.mode,
                      notes: firedReminderNotes,
                      spaceBelow: true,
                    ),
                    OptionalSection(
                      title: 'UPCOMING',
                      mode: modeNotifier.mode,
                      notes: upcomingReminderNotes,
                      spaceBelow: true,
                    ),
                  ],
                ),
              );
            }

            return NoRemindersScreen();
          }
          return NoRemindersScreen();
        });
  }
}
