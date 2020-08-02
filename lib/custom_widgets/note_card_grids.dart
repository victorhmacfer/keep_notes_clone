import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';

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

  final bool spaceBelow;

  final bool noSpacer;

  static const double _spacerHeight = 24;

  OptionalSection(
      {this.title = '', @required this.mode, @required this.notes, this.spaceBelow = false, this.noSpacer = false});

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

class SmallModeGrid extends StatelessWidget {
  final List<Note> notes;

  SmallModeGrid(this.notes);

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
