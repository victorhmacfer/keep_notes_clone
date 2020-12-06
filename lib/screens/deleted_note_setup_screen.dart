import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottomsheet_tile.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/utils/styles.dart';

import 'package:keep_notes_clone/main.dart';

import 'package:provider/provider.dart';

class DeletedNoteSetupScreen extends StatelessWidget {
  final Note note;

  DeletedNoteSetupScreen({@required this.note});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteSetupScreenController>(
          create: (context) => NoteSetupScreenController.fromNote(note),
        ),
        Provider<NoteSetupBloc>(
          create: (context) => NoteSetupBloc(repo),
        ),
      ],
      child: Scaffold(
          appBar: _DeletedNoteSetupAppBar(note: note),
          body: _DeletedNoteSetupBody(),
          bottomNavigationBar: _DeletedNoteSetupBottomAppBar()),
    );
  }
}

class _DeletedNoteSetupAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Note note;

  _DeletedNoteSetupAppBar({this.note});

  //FIXME: depending on framework code..
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: notifier.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGreyForColoredBg),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            notifier.closeRightBottomSheet();
            Navigator.pop(context);
          }),
    );
  }
}

class _DeletedNoteSetupBody extends StatelessWidget {
  List<Widget> _labelWidgets(List<Label> theLabels) {
    return theLabels
        .map((lab) => NoteSetupLabelChip(
              label: lab,
              deleted: true,
            ))
        .toList();
  }

  Widget _noteLabels(List<Label> theLabels) {
    if (theLabels.isEmpty) {
      return Container();
    }
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 4,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: _labelWidgets(theLabels),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    var noteLabels = notifier.futureLabels;

    return Container(
      color: notifier.selectedColor.getColor(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                padding:
                    EdgeInsets.only(top: 24, bottom: 40, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    TextField(
                      readOnly: true,
                      controller: notifier.titleController,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Title',
                        hintStyle:
                            TextStyle(color: appGreyForColoredBg, fontSize: 23),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      readOnly: true,
                      controller: notifier.textController,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Note',
                        hintStyle:
                            TextStyle(color: appGreyForColoredBg, fontSize: 15),
                      ),
                    ),
                    _noteLabels(noteLabels),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class _DeletedNoteSetupBottomAppBar extends StatelessWidget {
  Widget _rightBottomSheetBuilder(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);
    final noteSetupBloc = Provider.of<NoteSetupBloc>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'baseline_restore_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Restore',
            onTap: () {
              var noteToBeRestored = notifier.noteBeingEdited;
              noteToBeRestored.restore();
              noteSetupBloc.onNoteChanged(noteToBeRestored);

              notifier.closeRightBottomSheet();
              Navigator.pop(context);
            },
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'baseline_delete_forever_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Delete forever',
            onTap: () async {
              var shouldDelete = await showDialog<bool>(
                barrierDismissible:
                    true, // "shouldDelete" might be null as well.
                context: context,
                builder: _deleteConfirmationDialog,
              );

              if (shouldDelete) {
                var noteForPermanentDeletion = notifier.noteBeingEdited;
                noteSetupBloc.onDeleteNoteForever(noteForPermanentDeletion);
              }

              notifier.closeRightBottomSheet();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: notifier.selectedColor.getColor(),
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PngIconButton(
                    backgroundColor: notifier.selectedColor.getColor(),
                    pngIcon: PngIcon(
                      fileName: 'outline_add_box_black_48.png',
                      iconColor: appGreyForColoredBg,
                    ),
                    onTap: () {}),
                PngIconButton(
                    backgroundColor: notifier.selectedColor.getColor(),
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    ),
                    onTap: () {
                      if (notifier.rightBottomSheetOpen == false) {
                        notifier.openRightBottomSheet();
                        notifier.rightBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_rightBottomSheetBuilder);
                        notifier.shouldManuallyCloseRightSheet = true;
                        notifier.rightBottomSheetController.closed
                            .whenComplete(() {
                          notifier.shouldManuallyCloseRightSheet = false;
                        });
                      } else {
                        notifier.closeRightBottomSheet();
                      }
                    })
              ],
            ),
          ),
        ));
  }
}

Widget _deleteConfirmationDialog(BuildContext context) {
  return AlertDialog(
    title: Text('Delete this note forever?'),
    titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 16),
    titleTextStyle: cardTitleStyle,
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
        padding: EdgeInsets.fromLTRB(8, 12, 12, 12),
        color: appWhite,
        child: Text(
          text,
          style: dialogFlatButtonTextStyle,
        ),
      ),
    );
  }
}
