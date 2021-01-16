import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/reminder.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/screens/deleted_note_setup_screen.dart';
import 'package:provider/provider.dart';

class ExtendedNoteCard extends StatelessWidget {
  final Note note;

  //FIXME: this is terrible.. but will do for now.
  final String noteText;

  static const _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE = 43;

  ExtendedNoteCard(this.note)
      : noteText =
            (note.title.isEmpty && note.text.isEmpty && note.reminder != null)
                ? 'Empty reminder'
                : note.text;

  Widget _titleWidget() {
    return ((note.title != null) && (note.title.isNotEmpty))
        ? Text(
            note.title,
            style: cardTitleStyle,
          )
        : Container();
  }

  Widget _spacingWidget() {
    if ((note.title.isNotEmpty) && (noteText.isNotEmpty)) {
      return SizedBox(
        height: 12,
      );
    }
    return Container();
  }

  Widget _textWidget() {
    return ((noteText != null) && (noteText.isNotEmpty))
        ? Text(
            noteText,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: (noteText.length <= _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE)
                ? cardBigTextStyle
                : cardSmallTextStyle,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    var cardBorder = (multiNoteSelection.isSelected(note))
        ? Border.all(color: appBlack, width: 2)
        : Border.all(color: appCardBorderGrey, width: 1);

    return GestureDetector(
      onTap: () {
        if (multiNoteSelection.active) {
          multiNoteSelection.toggleNote(note);
        } else {
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
        }
      },
      onLongPress: () {
        if (multiNoteSelection.inactive) {
          multiNoteSelection.addNote(note);
        } else {
          multiNoteSelection.toggleNote(note);
        }
      },
      child: Hero(
        tag: 'notesetup-note-${note.id}',
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: NoteColor.getNoteColorFromIndex(note.colorIndex).getColor(),
            border: cardBorder,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _titleWidget(),
              _spacingWidget(),
              _textWidget(),
              ((note.labels?.isNotEmpty ?? false) || (note.reminder != null))
                  ? _ChipsContainer(
                      labels: note.labels,
                      reminder: note.reminder,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

const double _chipsContainerTopPadding = 12;

class _ChipsContainer extends StatelessWidget {
  final List<Label> labels;
  final Reminder reminder;

  _ChipsContainer({this.labels, this.reminder});

  List<Widget> _chips() {
    int maxTotalCharacters = (reminder != null) ? 24 : 32;
    const maxDisplayedLabels = 2;

    List<Widget> finalList = [];

    if (reminder != null) finalList.add(NoteCardReminderChip(reminder));

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
      padding: const EdgeInsets.only(top: _chipsContainerTopPadding),
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

class SmallNoteCard extends StatelessWidget {
  final Note note;

  final double estimatedHeight;

  final String noteText;

  static const _maxTextLengthWithBigFontSize = 15;
  static const _minHeightPercentageFactor = 30;
  static const _maxHeightPercentageFactor = 30;

  static const double _rightMargin = 8;
  static const double _verticalMargin = 4;
  static const double _padding = 16;
  static const double _spacerHeight = 12;
  static const double _chipHeight = 36;
  static const int _titleMaxLines = 2;
  static const int _textMaxLines = 10;

  static const int _titleBaseFontHeight = 22;
  static const int _textBaseFontHeight = 20;

  SmallNoteCard(this.note, this.estimatedHeight)
      : noteText =
            (note.title.isEmpty && note.text.isEmpty && note.reminder != null)
                ? 'Empty reminder'
                : note.text;

  Widget _titleWidget() {
    return ((note.title != null) && (note.title.isNotEmpty))
        ? Text(
            note.title,
            style: cardTitleStyle,
            maxLines: _titleMaxLines,
            overflow: TextOverflow.ellipsis,
          )
        : Container();
  }

  Widget _spacingWidget() {
    if ((note.title.isNotEmpty) && (noteText.isNotEmpty)) {
      return SizedBox(
        height: _spacerHeight,
      );
    }
    return Container();
  }

  Widget _textWidget() {
    return ((noteText != null) && (noteText.isNotEmpty))
        ? Text(
            noteText,
            maxLines: _textMaxLines,
            overflow: TextOverflow.ellipsis,
            style: (noteText.length <= _maxTextLengthWithBigFontSize)
                ? cardBigTextStyle
                : cardSmallTextStyle,
          )
        : Container();
  }

  //FIXME: ASSUMES TWO COLUMN GRID FOR NOW
  static double estimateHeight(Note note, double textScalingFactor) {
    double systemFontSizeVariationFactor = 1;
    if (textScalingFactor < 0.8) {
      systemFontSizeVariationFactor = 0.85;
    } else if (textScalingFactor > 1.1) {
      systemFontSizeVariationFactor = 1.5;
    } else if (textScalingFactor > 1.2) {
      systemFontSizeVariationFactor = 2;
    }

    final double titleCharsPerLine = (textScalingFactor > 1.2) ? 12 : 18;
    final double titleFontHeight =
        _titleBaseFontHeight * systemFontSizeVariationFactor;

    final double textCharsPerLine = 20 * (1 / systemFontSizeVariationFactor);
    final double textFontHeight =
        _textBaseFontHeight * systemFontSizeVariationFactor;

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
      //account for new line characters.. single char that adds a whole line
      // to the count !
      int newLineCharacterCount = 0;
      for (var codeUnit in text.codeUnits) {
        if (String.fromCharCode(codeUnit) == '\n') {
          newLineCharacterCount += 1;
        }
      }

      int textLineCount = min(
          ((text.length / textCharsPerLine).ceil() + newLineCharacterCount),
          _textMaxLines);

      totalHeight += textLineCount * textFontHeight;
    }

    if (title.isNotEmpty && text.isNotEmpty) {
      totalHeight += _spacerHeight;
    }

    var hasReminder = note.reminder != null;
    var hasAnyLabel = note.labels.isNotEmpty;

    var hasAnyChip = hasReminder || hasAnyLabel;

    if (hasAnyChip) {
      totalHeight += _chipHeight + _chipsContainerTopPadding;
    }

    var hasReminderAndManyLabels = (note.labels.length >= 2) && hasReminder;

    if (hasReminderAndManyLabels) {
      totalHeight += 2 * _chipHeight;
    }

    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    var cardBorder = (multiNoteSelection.isSelected(note))
        ? Border.all(color: appBlack, width: 2)
        : Border.all(color: appCardBorderGrey, width: 1);

    return GestureDetector(
      onTap: () {
        if (multiNoteSelection.active) {
          multiNoteSelection.toggleNote(note);
        } else {
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
        }
      },
      onLongPress: () {
        if (multiNoteSelection.inactive) {
          multiNoteSelection.addNote(note);
        } else {
          multiNoteSelection.toggleNote(note);
        }
      },
      child: Hero(
        tag: 'notesetup-note-${note.id}',
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight:
                  estimatedHeight * (1 - (_minHeightPercentageFactor / 100)),
              maxHeight:
                  estimatedHeight * (1 + (_maxHeightPercentageFactor / 100))),
          child: Container(
            margin: EdgeInsets.fromLTRB(
                0, _verticalMargin, _rightMargin, _verticalMargin),
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              color:
                  NoteColor.getNoteColorFromIndex(note.colorIndex).getColor(),
              border: cardBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleWidget(),
                _spacingWidget(),
                _textWidget(),
                ((note.labels?.isNotEmpty ?? false) || (note.reminder != null))
                    ? _ChipsContainer(
                        labels: note.labels,
                        reminder: note.reminder,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
