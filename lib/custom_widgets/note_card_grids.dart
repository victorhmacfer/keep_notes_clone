import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';

class DismissibleExtendedModeList extends StatelessWidget {
  final List<Note> notes;

  final NoteArchiverBloc bloc;

  DismissibleExtendedModeList({@required this.notes, @required this.bloc});

  Widget _cardBuilder(Note note) => Dismissible(
        key: ValueKey('extended_nc_${note.id}'),
        onDismissed: (_) {
          bloc.archiveNote(note);
        },
        child: ExtendedNoteCard(note),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notes.map(_cardBuilder).toList(),
    );
  }
}

class ExtendedModeList extends StatelessWidget {
  final List<Note> notes;

  ExtendedModeList(this.notes);

  Widget _cardBuilder(Note note) => ExtendedNoteCard(note);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notes.map(_cardBuilder).toList(),
    );
  }
}

class OptionalSection extends StatelessWidget {
  final NoteCardMode mode;

  final List<Note> notes;

  final String title;

  final bool spaceBelow;

  final bool noSpacer;

  static const double _spacerHeight = 24;

  OptionalSection(
      {this.title = '',
      @required this.mode,
      @required this.notes,
      this.spaceBelow = false,
      this.noSpacer = false});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Container();
    }

    double spacerHeight = (noSpacer) ? 0 : _spacerHeight;

    return Column(
      children: <Widget>[
        SizedBox(
          height: (spaceBelow) ? 0 : spacerHeight,
        ),
        (title.isNotEmpty) ? CardTypeSectionTitle(title) : Container(),
        (mode == NoteCardMode.extended)
            ? ExtendedModeList(notes)
            : SmallModeGrid(notes),
        SizedBox(
          height: (spaceBelow) ? spacerHeight : 0,
        ),
      ],
    );
  }
}

class DismissibleSmallModeGrid extends StatelessWidget {
  final List<Note> notes;

  final NoteArchiverBloc bloc;

  DismissibleSmallModeGrid({@required this.notes, @required this.bloc});

  void dismissibleAssignCardsToColumns(List<Note> theNotes, List<Widget> first,
      List<Widget> second, double textSF) {
    double accumFirstHeight = 0;
    double accumSecondHeight = 0;

    for (var n in theNotes) {
      var estimatedHeight = SmallNoteCard.estimateHeight(n, textSF);

      var theWidget = Dismissible(
        key: ValueKey('extended_nc_${n.id}'),
        onDismissed: (_) {
          bloc.archiveNote(n);
        },
        child: SmallNoteCard(n, estimatedHeight),
      );

      if ((accumFirstHeight == 0) ||
          (accumFirstHeight + estimatedHeight <=
              accumSecondHeight + estimatedHeight)) {
        first.add(theWidget);
        accumFirstHeight += estimatedHeight;
      } else {
        second.add(theWidget);
        accumSecondHeight += estimatedHeight;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    List<Widget> c1 = [];
    List<Widget> c2 = [];
    dismissibleAssignCardsToColumns(notes, c1, c2, mq.textScaleFactor);

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

class SmallModeGrid extends StatelessWidget {
  final List<Note> notes;

  SmallModeGrid(this.notes);

  void assignCardsToColumns(List<Note> theNotes, List<Widget> first,
      List<Widget> second, double textSF) {
    double accumFirstHeight = 0;
    double accumSecondHeight = 0;

    for (var n in theNotes) {
      var estimatedHeight = SmallNoteCard.estimateHeight(n, textSF);
      if ((accumFirstHeight == 0) ||
          (accumFirstHeight + estimatedHeight <=
              accumSecondHeight + estimatedHeight)) {
        first.add(SmallNoteCard(n, estimatedHeight));
        accumFirstHeight += estimatedHeight;
      } else {
        second.add(SmallNoteCard(n, estimatedHeight));
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
