import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class MultiNoteSelectionAppBar extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteTrackingBloc noteBloc;

  MultiNoteSelectionAppBar({@required this.notifier, @required this.noteBloc});

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
      actionsIconTheme: IconThemeData(color: appSettingsBlue),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
            pngIcon: PngIcon(
              fileName: (notifier.willPin)
                  ? 'outline_push_pin_black_48.png'
                  : 'baseline_push_pin_black_48.png',
              iconColor: appSettingsBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            onTap: () {
              notifier.pinOrUnpin();
              var changedNotes = notifier.selectedNotes;
              noteBloc.manyNotesChanged(changedNotes);
              notifier.cancel();
            },
            backgroundColor: appWhite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
            pngIcon: PngIcon(
              fileName: 'outline_add_alert_black_48.png',
              iconColor: appSettingsBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            onTap: () {},
            backgroundColor: appWhite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
            pngIcon: PngIcon(
              fileName: 'outline_palette_black_48.png',
              iconColor: appSettingsBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            onTap: () {},
            backgroundColor: appWhite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
            pngIcon: PngIcon(
              fileName: 'outline_label_black_48.png',
              iconColor: appSettingsBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            onTap: () {},
            backgroundColor: appWhite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PngIconButton(
            pngIcon: PngIcon(
              fileName: 'outline_more_vert_black_48.png',
              iconColor: appSettingsBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            onTap: () {},
            backgroundColor: appWhite,
          ),
        ),
      ],
    );
  }
}
