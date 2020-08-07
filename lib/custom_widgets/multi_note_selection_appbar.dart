import 'package:flutter/material.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class MultiNoteSelectionAppBar extends StatelessWidget {
  final MultiNoteSelection notifier;

  MultiNoteSelectionAppBar(this.notifier);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      brightness: Brightness.light,
      backgroundColor: appWhite,
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            notifier.cancel();
          }),
      iconTheme: IconThemeData(color: appSettingsBlue),
      title: Text(
        notifier.selectedCount.toString(),
        style: cardTitleStyle.copyWith(fontSize: 19, color: appSettingsBlue),
      ),
    );
  }
}
