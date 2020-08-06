import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

Widget deleteConfirmationDialog(BuildContext context) {
  return AlertDialog(
    title: Text('Delete label?'),
    titlePadding: EdgeInsets.fromLTRB(24, 16, 24, 0),
    titleTextStyle: cardTitleStyle,
    content: Text(
        "We'll delete this label and remove it from all of your Keep notes. Your notes won't be deleted."),
    contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
    actions: <Widget>[
      _CustomFlatButton('Cancel', onTap: () {
        Navigator.pop<bool>(context, false);
      }),
      _CustomFlatButton('Delete', onTap: () {
        Navigator.pop<bool>(context, true);
      }),
    ],
  );
}

class _CustomFlatButton extends StatelessWidget {
  final String text;

  final void Function() onTap;

  _CustomFlatButton(this.text, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
        color: appWhite,
        child: Text(
          text,
          style: dialogFlatButtonTextStyle,
        ),
      ),
    );
  }
}
