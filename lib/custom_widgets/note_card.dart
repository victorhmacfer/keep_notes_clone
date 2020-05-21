import 'package:flutter/material.dart';

import 'package:keep_notes_clone/styles.dart';
import 'package:keep_notes_clone/colors.dart';

class NoteCard extends StatelessWidget {
  final String title;

  final String text;

  final CardColor color;

  static const _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE = 43;

  NoteCard({this.title, this.text, this.color = CardColor.white});

  Widget _title(String theTitle) {
    return (theTitle != null)
        ? Text(
            theTitle,
            style: cardTitleStyle,
          )
        : Container();
  }

  Widget _spacing() {
    if ((title != null) && (text != null)) {
      return SizedBox(
        height: 12,
      );
    }
    return Container();
  }

  Widget _text(String theText) {
    return (theText != null)
        ? Text(
            theText,
            style: (theText.length <= _MAX_TEXT_LENGTH_WITH_BIG_FONTSIZE)
                ? cardBigTextStyle
                : cardSmallTextStyle,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Container(
        padding: EdgeInsets.all(16),
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
      ),
    );
  }
}
