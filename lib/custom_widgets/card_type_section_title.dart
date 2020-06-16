import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class CardTypeSectionTitle extends StatelessWidget {
  final String title;

  const CardTypeSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhite,
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: drawerLabelsEditStyle.copyWith(fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }
}
