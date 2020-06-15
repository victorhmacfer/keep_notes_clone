import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class NoteSetupLabelChip extends StatelessWidget {
  final Label label;

  NoteSetupLabelChip({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: appGreyForColoredBg, width: 1),
      ),
      child: Text(
        label.text,
        style: drawerItemStyle.copyWith(fontSize: 13),
      ),
    );
  }
}

class NoteCardLabelChip extends StatelessWidget {
  final String labelText;
  final int index;

  NoteCardLabelChip({@required this.index, @required this.labelText});

  @override
  Widget build(BuildContext context) {
    double leftMargin = (index != 0) ? 2 : 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: EdgeInsets.only(left: leftMargin, right: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appGreyForColoredBg, width: 1),
      ),
      child: Text(
        labelText,
        style: drawerItemStyle.copyWith(fontSize: 12),
      ),
    );
  }
}
