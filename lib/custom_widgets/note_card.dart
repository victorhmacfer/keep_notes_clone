import 'package:flutter/material.dart';

import 'package:keep_notes_clone/styles.dart';
import 'package:keep_notes_clone/colors.dart';

class NoteCard extends StatelessWidget {
  final String title;

  final String text;

  final NoteColor color;

  static const _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE = 43;

  NoteCard({this.title = '', this.text = '', this.color = NoteColor.white});

  Widget _title(String theTitle) {
    return ((theTitle != null) && (theTitle.isNotEmpty))
        ? Text(
            theTitle,
            style: cardTitleStyle,
          )
        : Container();
  }

  Widget _spacing() {
    if ((title.isNotEmpty) && (text.isNotEmpty)) {
      return SizedBox(
        height: 12,
      );
    }
    return Container();
  }

  Widget _text(String theText) {
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.getColor(),
        border: Border.all(color: appCardBorderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(title),
          _spacing(),
          _text(text),
        ],
      ),
    );
  }
}
