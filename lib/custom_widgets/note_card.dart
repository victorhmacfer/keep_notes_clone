import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

import 'package:keep_notes_clone/screens/deleted_note_setup_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  final String _title;
  String _text;
  final NoteColor _color;

  static const _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE = 43;

  NoteCard({@required this.note})
      : _title = note.title,
        _text = note.text,
        _color = NoteColor.getNoteColorFromIndex(note.colorIndex) {
    if (_title.isEmpty && _text.isEmpty && (note.reminderTime != null)) {
      var instant = reminderNotificationDateText(note.reminderTime);
      _text = 'Reminder at $instant';
    }
  }

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
            
            ((note.labels?.isNotEmpty ?? false) || (note.reminderTime != null))
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
      var text = labels[i].name;
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

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: FractionallySizedBox(
        widthFactor: 0.9,
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

class CrazyGridNoteCard extends StatelessWidget {
  final Note note;

  final String _title;
  String _text;
  final NoteColor _color;

  static const _maxTextLengthWithBigFontSize = 15;
  static const _minHeightPercentageFactor = 20; // cannot be higher than 100
  static const _maxHeightPercentageFactor = 40;

  static const double _rightMargin = 8;
  static const double _verticalMargin = 4;
  static const double _padding = 16;
  static const double _spacerHeight = 12;
  static const double _chipHeight = 24;
  static const int _titleMaxLines = 2;
  static const int _textMaxLines = 10;

  CrazyGridNoteCard(this.note)
      : _title = note.title,
        _text = note.text,
        _color = NoteColor.getNoteColorFromIndex(note.colorIndex) {
    if (_title.isEmpty && _text.isEmpty && (note.reminderTime != null)) {
      var instant = reminderNotificationDateText(note.reminderTime);
      _text = 'Reminder at $instant';
    }
  }

  Widget _titleWidget(String theTitle) {
    return ((theTitle != null) && (theTitle.isNotEmpty))
        ? Text(
            theTitle,
            style: cardTitleStyle,
            maxLines: _titleMaxLines,
            overflow: TextOverflow.ellipsis,
          )
        : Container();
  }

  Widget _spacingWidget() {
    if ((_title.isNotEmpty) && (_text.isNotEmpty)) {
      return SizedBox(
        height: _spacerHeight,
      );
    }
    return Container();
  }

  Widget _textWidget(String theText) {
    return ((theText != null) && (theText.isNotEmpty))
        ? Text(
            theText,
            maxLines: _textMaxLines,
            overflow: TextOverflow.ellipsis,
            style: (theText.length <= _maxTextLengthWithBigFontSize)
                ? cardBigTextStyle
                : cardSmallTextStyle,
          )
        : Container();
  }

  //FIXME: this function is very tightly coupled to a lot of things, such as:
// screen width, paddings and margins used in the notecard,
// real fontsizes (subject to system settings if phone uses smaller/larger fonts)...
//FIXME: ASSUMES TWO COLUMN GRID FOR NOW
  double estimateHeight(Note note) {
    //TODO: comment about coupling to font style
    const titleCharsPerLine = 20;
    const titleFontHeight = 18;

    const textCharsPerLine = 22;
    const textFontHeight = 16;

    double totalHeight = 0;

    totalHeight += 2 * _padding;
    totalHeight += 2 * _verticalMargin;

    var title = note.title;
    if (title.isNotEmpty) {
      int titleLineCount =
          min(((title.length / titleCharsPerLine).ceil()), _titleMaxLines);
      totalHeight += titleLineCount * titleFontHeight;
    }

    var text = note.text;
    if (text.isNotEmpty) {
      int textLineCount =
          min(((text.length / textCharsPerLine).ceil()), _textMaxLines);
      totalHeight += textLineCount * textFontHeight;
    }

    if (title.isNotEmpty && text.isNotEmpty) {
      totalHeight += _spacerHeight;
    }

    var hasReminder = note.reminderTime != null;
    if (hasReminder) {
      totalHeight += _chipHeight;
    }

    var hasAnyLabel = note.labels.isNotEmpty;
    if (hasAnyLabel) {
      totalHeight += _chipHeight;
      if (note.labels.length >= 3) {
        totalHeight += _chipHeight;
      }
    }

    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    var heightEstimation = estimateHeight(note);

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 0,
          maxWidth: double.infinity,
          minHeight:
              heightEstimation * (1 - (_minHeightPercentageFactor / 100)),
          maxHeight:
              heightEstimation * (1 + (_maxHeightPercentageFactor / 100))),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            0, _verticalMargin, _rightMargin, _verticalMargin),
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: _color.getColor(),
          border: Border.all(color: appCardBorderGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _titleWidget(_title),
            _spacingWidget(),
            _textWidget(_text),

            ((note.labels?.isNotEmpty ?? false) || (note.reminderTime != null))
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
