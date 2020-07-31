import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'package:keep_notes_clone/models/note.dart';

const double _bottomPadding = 56;

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
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SearchAppBar(),
            SliverToBoxAdapter(
              child: StreamBuilderBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class FluidGrid extends StatelessWidget {
  final List<Note> notes;

  FluidGrid(this.notes);

  void assignCardsToColumns(List<Note> theNotes, List<Widget> first,
      List<Widget> second, double textSF) {
    double accumFirstHeight = 0;
    double accumSecondHeight = 0;

    for (var n in theNotes) {
      var estimatedHeight = CrazyGridNoteCard.estimateHeight(n, textSF);
      if ((accumFirstHeight == 0) ||
          (accumFirstHeight + estimatedHeight <=
              accumSecondHeight + estimatedHeight)) {
        first.add(CrazyGridNoteCard(n));
        accumFirstHeight += estimatedHeight;
      } else {
        second.add(CrazyGridNoteCard(n));
        accumSecondHeight += estimatedHeight;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    List<Widget> c1 = [];
    List<Widget> c2 = [];
    assignCardsToColumns(notes, c1, c2, mq.textScaleFactor);

    return Container(
      margin: EdgeInsets.only(left: 8),
      // color: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: c1,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: c2,
            ),
          ),
        ],
      ),
    );
  }
}

class ExtendedModeList extends StatelessWidget {
  final List<Note> notes;

  ExtendedModeList(this.notes);

  Widget _noteCardBuilder(Note note) => NoteCard(note: note);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notes.map(_noteCardBuilder).toList(),
    );
  }
}

class OptionalSection extends StatelessWidget {
  final NoteCardMode mode;

  final List<Note> notes;

  final String title;

  OptionalSection(
      {@required this.mode, @required this.notes, @required this.title});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        CardTypeSectionTitle(title),
        (mode == NoteCardMode.extended)
            ? ExtendedModeList(notes)
            : FluidGrid(notes),
      ],
    );
  }
}

class StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<HomeViewModel>(
      stream: noteBloc.homeViewModelStream,
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
                    : FluidGrid(unpinnedNotes),
              );
            }

            return Container(
              margin: EdgeInsets.only(bottom: _bottomPadding),
              child: Column(
                children: <Widget>[
                  CardTypeSectionTitle('PINNED'),
                  (modeNotifier.mode == NoteCardMode.extended)
                      ? ExtendedModeList(pinnedNotes)
                      : FluidGrid(pinnedNotes),
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
