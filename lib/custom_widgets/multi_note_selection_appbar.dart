import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

//FIXME: the appbars are DUPLICATED !!! fix later

enum _MultiNoteMenuAction { archive, delete }

class SliverMultiNoteSelectionAppBar extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteTrackingBloc noteBloc;

  SliverMultiNoteSelectionAppBar(
      {@required this.notifier, @required this.noteBloc});

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
            onTap: () async {
              var newColor = await showDialog<NoteColor>(
                context: context,
                builder: _changeColorDialog,
                barrierDismissible: true,
              );
              if (newColor != null) {
                notifier.changeColorTo(newColor);
                var changedNotes = notifier.selectedNotes;
                noteBloc.manyNotesChanged(changedNotes);
                notifier.cancel();
              }
            },
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
        PopupMenuButton<_MultiNoteMenuAction>(
          icon: Icon(
            Icons.more_vert,
            color: appSettingsBlue,
          ),
          onSelected: (action) {
            if (action == _MultiNoteMenuAction.archive) {
              notifier.archive();
              var changedNotes = notifier.selectedNotes;
              noteBloc.manyNotesChanged(changedNotes);
              notifier.cancel();
            } else if (action == _MultiNoteMenuAction.delete) {
              notifier.delete();
              var changedNotes = notifier.selectedNotes;
              noteBloc.manyNotesChanged(changedNotes);
              notifier.cancel();
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<_MultiNoteMenuAction>>[
            PopupMenuItem<_MultiNoteMenuAction>(
              value: _MultiNoteMenuAction.archive,
              child: Text('Archive'),
            ),
            PopupMenuItem<_MultiNoteMenuAction>(
              value: _MultiNoteMenuAction.delete,
              child: Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}

//FIXME: the appbars are DUPLICATED !!! fix later

class BoxMultiNoteSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final MultiNoteSelection notifier;
  final NoteTrackingBloc noteBloc;

  BoxMultiNoteSelectionAppBar(
      {@required this.notifier, @required this.noteBloc});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            onTap: () async {
              var newColor = await showDialog<NoteColor>(
                context: context,
                builder: _changeColorDialog,
                barrierDismissible: true,
              );
              if (newColor != null) {
                notifier.changeColorTo(newColor);
                var changedNotes = notifier.selectedNotes;
                noteBloc.manyNotesChanged(changedNotes);
                notifier.cancel();
              }
            },
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
        PopupMenuButton<_MultiNoteMenuAction>(
          icon: Icon(
            Icons.more_vert,
            color: appSettingsBlue,
          ),
          onSelected: (action) {
            if (action == _MultiNoteMenuAction.archive) {
              notifier.archive();
              var changedNotes = notifier.selectedNotes;
              noteBloc.manyNotesChanged(changedNotes);
              notifier.cancel();
            } else if (action == _MultiNoteMenuAction.delete) {
              notifier.delete();
              var changedNotes = notifier.selectedNotes;
              noteBloc.manyNotesChanged(changedNotes);
              notifier.cancel();
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<_MultiNoteMenuAction>>[
            PopupMenuItem<_MultiNoteMenuAction>(
              value: _MultiNoteMenuAction.archive,
              child: Text('Archive'),
            ),
            PopupMenuItem<_MultiNoteMenuAction>(
              value: _MultiNoteMenuAction.delete,
              child: Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _changeColorDialog(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;

  return AlertDialog(
    title: Text('Note color'),
    titlePadding: EdgeInsets.fromLTRB(20, 20, 0, 0),
    titleTextStyle:
        cardTitleStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
    insetPadding: EdgeInsets.symmetric(horizontal: 8),
    content: Container(
      // color: Colors.red[100],
      width: screenWidth * 0.85,
      height: 190,
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.65,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _ColorCircle(NoteColor.white),
            _ColorCircle(NoteColor.red),
            _ColorCircle(NoteColor.orange),
            _ColorCircle(NoteColor.yellow),
            _ColorCircle(NoteColor.darkBlue),
            _ColorCircle(NoteColor.blue),
            _ColorCircle(NoteColor.cyan),
            _ColorCircle(NoteColor.green),
            _ColorCircle(NoteColor.purple),
            _ColorCircle(NoteColor.pink),
            _ColorCircle(NoteColor.brown),
            _ColorCircle(NoteColor.grey),
          ],
        ),
      ),
    ),
  );
}

class _ColorCircle extends StatelessWidget {
  final NoteColor noteColor;

  _ColorCircle(this.noteColor);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.83,
      heightFactor: 0.83,
      child: GestureDetector(
        onTap: () {
          Navigator.pop<NoteColor>(context, noteColor);
        },
        child: Container(
          decoration: BoxDecoration(
              color: noteColor.getColor(),
              border: Border.all(width: 0.5, color: appGreyForColoredBg),
              borderRadius: BorderRadius.circular(40)),
        ),
      ),
    );
  }
}
