import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/note.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/screens/create_edit_note_screen.dart';

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEditNoteScreen(note: note)));
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
          ],
        ),
      ),
    );
  }
}
