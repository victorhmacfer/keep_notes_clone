import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:provider/provider.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';

import 'package:keep_notes_clone/custom_widgets/bottomsheet_tile.dart';
import 'package:keep_notes_clone/custom_widgets/label_chip.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';

import 'package:keep_notes_clone/screens/note_labeling_screen.dart';

import 'package:keep_notes_clone/utils/colors.dart';

class NoteSetupScreen extends StatelessWidget {
  final Note note;

  NoteSetupScreen({this.note});

  @override
  Widget build(BuildContext context) {
    NoteSetupScreenController controller = (note == null)
        ? NoteSetupScreenController()
        : NoteSetupScreenController.fromNote(note: note);

    _NoteSetupAppBar theAppBar =
        (note == null) ? _NoteSetupAppBar() : _NoteSetupAppBar(note: note);

    return ChangeNotifierProvider<NoteSetupScreenController>.value(
      value: controller,
      child: Scaffold(
          appBar: theAppBar,
          body: _NoteSetupBody(),
          bottomNavigationBar: _MyStickyBottomAppBar()),
    );
  }
}

class _NoteSetupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Note note;

  _NoteSetupAppBar({this.note});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);
    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return AppBar(
      backgroundColor: notifier.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGrey),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var title = notifier.titleController.text;
            var text = notifier.textController.text;
            var colorIndex = notifier.selectedColorIndex;
            var pinned = notifier.isPinned;
            var labels = notifier.futureLabels;
            if (title.isNotEmpty || text.isNotEmpty) {
              if (note == null) {
                noteBloc.onCreateNewNote(
                    title: title,
                    text: text,
                    colorIndex: colorIndex,
                    pinned: pinned,
                    archived: false,
                    labels: labels);
              } else {
                note.title = title;
                note.text = text;
                note.colorIndex = colorIndex;
                note.pinned = pinned;
                note.labels = labels;
                noteBloc.onNoteChanged();
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
              pngIcon: (notifier.isPinned)
                  ? PngIcon(fileName: 'baseline_push_pin_black_48.png')
                  : PngIcon(fileName: 'outline_push_pin_black_48.png'),
              onTap: () {
                var pinOrUnpin =
                    (notifier.isPinned) ? notifier.unpinNote : notifier.pinNote;
                pinOrUnpin();
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              pngIcon: PngIcon(fileName: 'outline_add_alert_black_48.png'),
              onTap: () {}),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              pngIcon: PngIcon(fileName: 'outline_archive_black_48.png'),
              onTap: () {
                var title = notifier.titleController.text;
                var text = notifier.textController.text;
                var colorIndex = notifier.selectedColorIndex;
                var labels = notifier.futureLabels;
                if (title.isNotEmpty || text.isNotEmpty) {
                  if (note == null) {
                    noteBloc.onCreateNewNote(
                        title: title,
                        text: text,
                        colorIndex: colorIndex,
                        pinned: false,
                        archived: true,
                        labels: labels);
                  } else {
                    note.title = title;
                    note.text = text;
                    note.colorIndex = colorIndex;
                    note.archived = true;
                    note.labels = labels;
                    noteBloc.onNoteChanged();
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
                      controller: notifier.titleController,
                      focusNode: notifier.titleFocusNode,
                      onTap: () {
                        notifier.closeLeftBottomSheet();
                        notifier.closeRightBottomSheet();
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
                        hintStyle:
                            TextStyle(color: appGreyForColoredBg, fontSize: 23),
                      ),
                    ),
                    TextField(
                      controller: notifier.textController,
                      focusNode: notifier.textFocusNode,
                      autofocus: notifier.notEditing,
                      onTap: () {
                        notifier.closeLeftBottomSheet();
                        notifier.closeRightBottomSheet();
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
            pngIcon: PngIcon(fileName: 'outline_photo_camera_black_48.png'),
            text: 'Take photo',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_photo_black_48.png'),
            text: 'Add image',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_brush_black_48.png'),
            text: 'Drawing',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_mic_none_black_48.png'),
            text: 'Recording',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_check_box_black_48.png'),
            text: 'Checkboxes',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _rightBottomSheetBuilder(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);
    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_delete_black_48.png'),
            text: 'Delete',
            onTap: () {
              var noteForDeletion = notifier.noteToBeDeleted;
              if (noteForDeletion != null) {
                noteForDeletion.delete();
                noteBloc.onNoteChanged();
              }

              notifier.closeLeftBottomSheet();
              notifier.closeRightBottomSheet();
              Navigator.pop(context);
            },
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_file_copy_black_48.png'),
            text: 'Make a copy',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_share_black_48.png'),
            text: 'Send',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_person_add_black_48.png'),
            text: 'Collaborator',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'outline_label_black_48.png'),
            text: 'Labels',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<
                              NoteSetupScreenController>.value(
                            value: notifier,
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
                    pngIcon: PngIcon(
                      fileName: 'outline_add_box_black_48.png',
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
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
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
          _ColorSelectionCircle(index: 5, noteColor: NoteColor.lightBlue),
          _ColorSelectionCircle(index: 6, noteColor: NoteColor.mediumBlue),
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
