import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_labeling_bloc.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/reminder_setup_dialog.dart';
import 'package:provider/provider.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';

import 'package:keep_notes_clone/custom_widgets/bottomsheet_tile.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';

import 'package:keep_notes_clone/screens/note_labeling_screen.dart';

import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

import 'package:keep_notes_clone/main.dart';

class NoteSetupScreen extends StatelessWidget {
  final Note note;

  final Label label;

  NoteSetupScreen({this.note, this.label});

  @override
  Widget build(BuildContext context) {
    NoteSetupScreenController controller;
    _NoteSetupAppBar theAppBar;
    if (note == null) {
      if (label != null) {
        controller = NoteSetupScreenController.withLabel(label);
        theAppBar = _NoteSetupAppBar(label: label);
      } else {
        controller = NoteSetupScreenController();
        theAppBar = _NoteSetupAppBar();
      }
    } else {
      controller = NoteSetupScreenController.fromNote(note);
      theAppBar = _NoteSetupAppBar(note: note);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteSetupScreenController>.value(
            value: controller),
        Provider<NoteSetupBloc>(
          create: (context) => NoteSetupBloc(globalNoteRepo),
        ),
      ],
      child: Scaffold(
          appBar: theAppBar,
          body: _NoteSetupBody(),
          bottomNavigationBar: _MyStickyBottomAppBar()),
    );
  }
}

class _NoteSetupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Note note;

  final Label label;

  _NoteSetupAppBar({this.note, this.label});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);
    final noteSetupBloc = Provider.of<NoteSetupBloc>(context);

    bool shouldUnarchive = note?.archived ?? false;

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: notifier.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGreyForColoredBg),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (notifier.canApplySetupModelToNote) {
              if (notifier.notEditing) {
                noteSetupBloc.onCreateNote(notifier.noteSetupModel);
              } else {
                notifier.tryToUpdateLastEdited();
                note.updateWith(notifier.noteSetupModel);
                noteSetupBloc.onNoteChanged(note);
              }
            }
            notifier.closeLeftBottomSheet();
            notifier.closeRightBottomSheet();
            Navigator.pop(context);
          }),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              backgroundColor: notifier.selectedColor.getColor(),
              pngIcon: (notifier.isPinned)
                  ? PngIcon(
                      fileName: 'baseline_push_pin_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    )
                  : PngIcon(
                      fileName: 'outline_push_pin_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    ),
              onTap: () {
                var pinOrUnpin =
                    (notifier.isPinned) ? notifier.unpinNote : notifier.pinNote;
                pinOrUnpin();
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              backgroundColor: notifier.selectedColor.getColor(),
              pngIcon: PngIcon(
                fileName: 'outline_add_alert_black_48.png',
                iconColor: appIconGreyForColoredBg,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<NoteSetupScreenController>.value(
                          value: notifier),
                      Provider(
                          create: (context) => NoteSetupBloc(globalNoteRepo)),
                    ],
                    child: ReminderSetupDialog(),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              backgroundColor: notifier.selectedColor.getColor(),
              pngIcon: (shouldUnarchive)
                  ? PngIcon(
                      fileName: 'outline_unarchive_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    )
                  : PngIcon(
                      fileName: 'outline_archive_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    ),
              onTap: () {
                if (notifier.canApplySetupModelToNote) {
                  if (notifier.notEditing) {
                    noteSetupBloc.onCreateNote(notifier.noteSetupModel,
                        createArchived: true);
                  } else {
                    notifier.tryToUpdateLastEdited();
                    note.updateWith(notifier.noteSetupModel);

                    if (shouldUnarchive) {
                      if (note.archived) {
                        note.archived = false;
                      }
                    } else {
                      note.archived = true;
                    }
                    noteSetupBloc.onNoteChanged(note);
                  }
                }
                notifier.closeLeftBottomSheet();
                notifier.closeRightBottomSheet();
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}

class _NoteSetupBody extends StatelessWidget {
  List<Widget> _labelWidgets(List<Label> theLabels) {
    return theLabels.map((lab) => NoteSetupLabelChip(label: lab)).toList();
  }

  Widget _noteChips(
      DateTime reminderTime, bool reminderExpired, List<Label> theLabels) {
    if (theLabels.isEmpty && (reminderTime == null)) {
      return Container();
    }
    List<Widget> chipList = [];

    if (reminderTime != null) {
      chipList.add(NoteSetupReminderChip(reminderTime, reminderExpired));
    }

    chipList.addAll(_labelWidgets(theLabels));

    return Container(
      margin: EdgeInsets.only(top: 16),
      width: double.infinity,
      child: Wrap(
        spacing: 4,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: chipList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    var noteLabels = notifier.futureLabels;

    return GestureDetector(
      onTap: () {
        notifier.textFocusNode.requestFocus();
      },
      child: Container(
        color: notifier.selectedColor.getColor(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                  padding:
                      EdgeInsets.only(top: 24, bottom: 72, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: notifier.titleController,
                        focusNode: notifier.titleFocusNode,
                        onTap: () {
                          notifier.closeLeftBottomSheet();
                          notifier.closeRightBottomSheet();
                        },
                        onChanged: (text) {
                          notifier.markNoteAsDirty();
                        },
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 10,
                        cursorWidth: 1,
                        cursorColor: appIconGrey,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              color: appGreyForColoredBg, fontSize: 23),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: notifier.textController,
                        focusNode: notifier.textFocusNode,
                        autofocus: notifier.notEditing,
                        scrollPadding: const EdgeInsets.all(56),
                        onTap: () {
                          notifier.closeLeftBottomSheet();
                          notifier.closeRightBottomSheet();
                        },
                        onChanged: (text) {
                          notifier.markNoteAsDirty();
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 2000,
                        cursorWidth: 1,
                        cursorColor: appIconGrey,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                              color: appGreyForColoredBg, fontSize: 15),
                        ),
                      ),
                      _noteChips(notifier.savedReminderTime,
                          notifier.reminderExpired, noteLabels),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class _MyStickyBottomAppBar extends StatelessWidget {
  Widget _leftBottomSheetBuilder(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_photo_camera_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Take photo',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_photo_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Add image',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_brush_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Drawing',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_mic_none_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Recording',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_check_box_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Checkboxes',
            onTap: () {},
          ),
        ],
      ),
    );
  }

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
              fileName: 'outline_delete_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Delete',
            onTap: () {
              var noteForDeletion = notifier.noteBeingEdited;
              if (noteForDeletion != null) {
                noteForDeletion.delete();
                notifier.removeSavedReminder();
                noteSetupBloc.onNoteChanged(noteForDeletion);
              }

              notifier.closeLeftBottomSheet();
              notifier.closeRightBottomSheet();
              Navigator.pop(context);
            },
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_file_copy_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Make a copy',
            onTap: () {},
          ),
          // BottomSheetTile(
          //   noteSetupController: notifier,
          //   pngIcon: PngIcon(
          //     fileName: 'outline_share_black_48.png',
          //     iconColor: appIconGreyForColoredBg,
          //   ),
          //   text: 'Send',
          //   onTap: () {},
          // ),
          // BottomSheetTile(
          //   noteSetupController: notifier,
          //   pngIcon: PngIcon(
          //     fileName: 'outline_person_add_black_48.png',
          //     iconColor: appIconGreyForColoredBg,
          //   ),
          //   text: 'Collaborator',
          //   onTap: () {},
          // ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_label_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Labels',
            onTap: () {
              notifier.closeRightBottomSheet();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider<
                                      NoteSetupScreenController>.value(
                                  value: notifier),
                              Provider<NoteLabelingBloc>(
                                create: (context) =>
                                    NoteLabelingBloc(globalNoteRepo),
                              ),
                            ],
                            child: NoteLabelingScreen(),
                          )));
            },
          ),
          _ColorSelectionList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    var lastEditedText = noteSetupLastEditedText(notifier.noteLastEdited);

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
                      iconColor: appIconGreyForColoredBg,
                    ),
                    onTap: () {
                      if (notifier.leftBottomSheetOpen == false) {
                        notifier.titleFocusNode.unfocus();
                        notifier.textFocusNode.unfocus();
                        notifier.openLeftBottomSheet();
                        notifier.leftBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_leftBottomSheetBuilder);
                        notifier.shouldManuallyCloseLeftSheet = true;
                        notifier.leftBottomSheetController.closed
                            .whenComplete(() {
                          notifier.shouldManuallyCloseLeftSheet = false;
                        });
                      } else {
                        notifier.closeLeftBottomSheet();
                      }
                    }),
                Text(
                  lastEditedText,
                  style: TextStyle(color: appVeryDarkGreyForColoredBg),
                ),
                PngIconButton(
                    backgroundColor: notifier.selectedColor.getColor(),
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    ),
                    onTap: () {
                      if (notifier.rightBottomSheetOpen == false) {
                        notifier.titleFocusNode.unfocus();
                        notifier.textFocusNode.unfocus();
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

class _ColorSelectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      height: 52,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          _ColorSelectionCircle(index: 0, noteColor: NoteColor.white),
          _ColorSelectionCircle(index: 1, noteColor: NoteColor.red),
          _ColorSelectionCircle(index: 2, noteColor: NoteColor.orange),
          _ColorSelectionCircle(index: 3, noteColor: NoteColor.yellow),
          _ColorSelectionCircle(index: 4, noteColor: NoteColor.green),
          _ColorSelectionCircle(index: 5, noteColor: NoteColor.cyan),
          _ColorSelectionCircle(index: 6, noteColor: NoteColor.blue),
          _ColorSelectionCircle(index: 7, noteColor: NoteColor.darkBlue),
          _ColorSelectionCircle(index: 8, noteColor: NoteColor.purple),
          _ColorSelectionCircle(index: 9, noteColor: NoteColor.pink),
          _ColorSelectionCircle(index: 10, noteColor: NoteColor.brown),
          _ColorSelectionCircle(index: 11, noteColor: NoteColor.grey),
          SizedBox(
            width: 6,
          )
        ],
      ),
    );
  }
}

class _ColorSelectionCircle extends StatelessWidget {
  final NoteColor noteColor;
  final int index;

  _ColorSelectionCircle({this.noteColor, this.index});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return GestureDetector(
      onTap: () {
        notifier.selectedColorIndex = index;
      },
      child: Container(
        decoration: BoxDecoration(
            color: noteColor.getColor(),
            border: Border.all(width: 0.5, color: appGreyForColoredBg),
            borderRadius: BorderRadius.circular(20)),
        width: 32,
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Visibility(
            visible: notifier.selectedColorIndex == index,
            child: Icon(
              Icons.check,
              color: appGreyForColoredBg,
            )),
      ),
    );
  }
}
