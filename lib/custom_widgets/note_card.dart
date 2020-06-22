import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/screens/deleted_note_setup_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  final String _title;
  final String _text;
  final NoteColor _color;

  static const _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE = 43;

  NoteCard({@required this.note})
      : _title = note.title,
        _text = note.text,
        _color = NoteColor.getNoteColorFromIndex(note.colorIndex);

  Widget _titleWidget(String theTitle) {
    return ((theTitle != null) && (theTitle.isNotEmpty))
        ? Text(
            theTitle,
            style: cardTitleStyle,
          )
        : Container();
  }

  Widget _spacingWidget() {
    if ((_title.isNotEmpty) && (_text.isNotEmpty)) {
      return SizedBox(
        height: 12,
      );
    }
    return Container();
  }

  Widget _textWidget(String theText) {
    return ((theText != null) && (theText.isNotEmpty))
        ? Text(
            theText,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: (theText.length <= _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE)
                ? cardBigTextStyle
                : cardSmallTextStyle,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (note.deleted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeletedNoteSetupScreen(note: note)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteSetupScreen(note: note)));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: _color.getColor(),
          border: Border.all(color: appCardBorderGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _titleWidget(_title),
            _spacingWidget(),
            _textWidget(_text),
            (note.labels.isNotEmpty || (note.reminderTime != null))
                ? _ChipsContainer(
                    labels: note.labels,
                    reminderTime: note.reminderTime,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class _ChipsContainer extends StatelessWidget {
  final List<Label> labels;
  final DateTime reminderTime;

  _ChipsContainer({this.labels, this.reminderTime});

  List<Widget> _chips() {
    int maxTotalCharacters = (reminderTime != null) ? 24 : 32;
    const maxDisplayedLabels = 2;

    List<Widget> finalList = [];

    if (reminderTime != null) finalList.add(NoteCardReminderChip(reminderTime));


    int accumulatedCharacters = 0;
    bool addedPlusLabel = false;
    for (int i = 0; i < labels.length; i++) {
      var text = labels[i].text;
      int textLength = text.length;

      bool isWithinCharLimit =
          (accumulatedCharacters + textLength) <= maxTotalCharacters;
      bool canInsertCurrentLabel =
          isWithinCharLimit && (i < maxDisplayedLabels);

      if (canInsertCurrentLabel) {
        finalList.add(NoteCardLabelChip(text));
        accumulatedCharacters += textLength;
      } else if (addedPlusLabel == false) {
        finalList.add(NoteCardLabelChip('+${labels.length - i}'));
        addedPlusLabel = true;
      } else {
        finalList.add(Container());
      }
    }
    return finalList;
  }

  

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        width: screenWidth * 0.85,
        child: Container(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _chips(),
          ),
        ),
      ),
    );
  }
}
