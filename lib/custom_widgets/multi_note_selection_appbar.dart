import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

enum _MultiNoteMenuAction { archive, delete }

class SliverMultiNoteSelectionAppBar extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteChangerBloc noteChangerBloc;

  SliverMultiNoteSelectionAppBar(
      {@required this.notifier, @required this.noteChangerBloc});

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
        _PinButton(notifier: notifier, bloc: noteChangerBloc),
        // _ReminderButton(),
        _ChangeColorButton(notifier: notifier, bloc: noteChangerBloc),
        // _AddLabelButton(),
        _MenuButton(notifier: notifier, bloc: noteChangerBloc),
      ],
    );
  }
}

class BoxMultiNoteSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final MultiNoteSelection notifier;
  final NoteChangerBloc noteChangerBloc;

  BoxMultiNoteSelectionAppBar(
      {@required this.notifier, @required this.noteChangerBloc});

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
        _PinButton(notifier: notifier, bloc: noteChangerBloc),
        // _ReminderButton(),
        _ChangeColorButton(notifier: notifier, bloc: noteChangerBloc),
        // _AddLabelButton(),
        _MenuButton(notifier: notifier, bloc: noteChangerBloc),
      ],
    );
  }
}

class _PinButton extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteChangerBloc bloc;

  _PinButton({@required this.notifier, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PngIconButton(
        key: ValueKey('multi_note_selection_pin'),
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
          bloc.manyNotesChanged(changedNotes);
          notifier.cancel();
        },
        backgroundColor: appWhite,
      ),
    );
  }
}

class _ReminderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _ChangeColorButton extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteChangerBloc bloc;

  _ChangeColorButton({@required this.notifier, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PngIconButton(
        key: ValueKey('multi_note_selection_change_color'),
        pngIcon: PngIcon(
          fileName: 'outline_palette_black_48.png',
          iconColor: appSettingsBlue,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        onTap: () async {
          var newColor = await showDialog<NoteColor>(
            context: context,
            builder: (context) => _ChangeColorDialog(),
            barrierDismissible: true,
          );
          if (newColor != null) {
            notifier.changeColorTo(newColor);
            var changedNotes = notifier.selectedNotes;
            bloc.manyNotesChanged(changedNotes);
            notifier.cancel();
          }
        },
        backgroundColor: appWhite,
      ),
    );
  }
}

class _AddLabelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MultiNoteSelection notifier;
  final NoteChangerBloc bloc;

  _MenuButton({@required this.notifier, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MultiNoteMenuAction>(
      key: ValueKey('multi_note_selection_menu'),
      icon: Icon(
        Icons.more_vert,
        color: appSettingsBlue,
      ),
      onSelected: (action) {
        if (action == _MultiNoteMenuAction.archive) {
          notifier.archive();
          var changedNotes = notifier.selectedNotes;
          bloc.manyNotesChanged(changedNotes);
          notifier.cancel();
        } else if (action == _MultiNoteMenuAction.delete) {
          notifier.delete();
          var changedNotes = notifier.selectedNotes;
          bloc.manyNotesChanged(changedNotes);
          notifier.cancel();
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<_MultiNoteMenuAction>>[
        PopupMenuItem<_MultiNoteMenuAction>(
          key: ValueKey('multi_note_selection_menu_item_archive'),
          value: _MultiNoteMenuAction.archive,
          child: Text('Archive'),
        ),
        PopupMenuItem<_MultiNoteMenuAction>(
          key: ValueKey('multi_note_selection_menu_item_delete'),
          value: _MultiNoteMenuAction.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}

class _ChangeColorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          key: ValueKey(
              'multi_note_selection_color_circle_${noteColor.colorDescription}'),
          decoration: BoxDecoration(
              color: noteColor.getColor(),
              border: Border.all(width: 0.5, color: appGreyForColoredBg),
              borderRadius: BorderRadius.circular(40)),
        ),
      ),
    );
  }
}
