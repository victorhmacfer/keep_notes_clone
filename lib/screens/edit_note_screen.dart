import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/screens/note_labeling_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:keep_notes_clone/notifiers/note_editing.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/models/note.dart';

class EditNoteScreen extends StatelessWidget {
  final Note note;

  EditNoteScreen({@required this.note});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteEditingChangeNotifier>(
      create: (context) => NoteEditingChangeNotifier(note),
      child: Scaffold(
          appBar: _EditNoteAppBar(
            note: note,
          ),
          body: _EditNoteBody(),
          bottomNavigationBar: MyStickyBottomAppBar()),
    );
  }
}

class _EditNoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Note note;

  _EditNoteAppBar({@required this.note});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);
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
              note.title = title;
              note.text = text;
              note.colorIndex = colorIndex;
              note.pinned = pinned;
              note.labels = labels;
              noteBloc.onNoteEdited();
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
                if (title.isNotEmpty || text.isNotEmpty) {
                  note.title = title;
                  note.text = text;
                  note.colorIndex = colorIndex;
                  note.archived = true;
                  noteBloc.onNoteEdited();
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

class _EditNoteBody extends StatelessWidget {
  Widget _labelChip(Label theLabel) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: appGreyForColoredBg, width: 1),
      ),
      child: Text(
        theLabel.text,
        style: drawerItemStyle.copyWith(fontSize: 13),
      ),
    );
  }

  List<Widget> _labelWidgets(List<Label> theLabels) {
    return theLabels.map((label) => _labelChip(label)).toList();
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
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

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
                        hintStyle: TextStyle(color: appGreyForColoredBg, fontSize: 23),
                      ),
                    ),
                    TextField(
                      controller: notifier.textController,
                      focusNode: notifier.textFocusNode,
                      autofocus: false,
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
                        hintStyle: TextStyle(color: appGreyForColoredBg, fontSize: 15),
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

class MyStickyBottomAppBar extends StatelessWidget {
  Widget _leftBottomSheetBuilder(BuildContext context) {
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_camera_black_48.png'),
            text: 'Take photo',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_black_48.png'),
            text: 'Add image',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_brush_black_48.png'),
            text: 'Drawing',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_mic_none_black_48.png'),
            text: 'Recording',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_check_box_black_48.png'),
            text: 'Checkboxes',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _rightBottomSheetBuilder(BuildContext context) {
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_delete_black_48.png'),
            text: 'Delete',
            onTap: () {
              var theNoteBeingEdited = notifier.noteBeingEdited;
              theNoteBeingEdited.delete();
              noteBloc.onNoteDeleted();
              notifier.closeLeftBottomSheet();
              notifier.closeRightBottomSheet();
              Navigator.pop(context);
            },
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_file_copy_black_48.png'),
            text: 'Make a copy',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_share_black_48.png'),
            text: 'Send',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_person_add_black_48.png'),
            text: 'Collaborator',
            onTap: () {},
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_label_black_48.png'),
            text: 'Labels',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<
                              NoteEditingChangeNotifier>.value(
                            value: notifier,
                            child: NoteLabelingScreenForEdit(),
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
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

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
  Widget _colorSelectionCircle(
      {NoteColor noteColor, int index, NoteEditingChangeNotifier notifier}) {
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
            child: Icon(Icons.check, color: appGreyForColoredBg,)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

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
          _colorSelectionCircle(
              index: 0, noteColor: NoteColor.white, notifier: notifier),
          _colorSelectionCircle(
              index: 1, noteColor: NoteColor.red, notifier: notifier),
          _colorSelectionCircle(
              index: 2, noteColor: NoteColor.orange, notifier: notifier),
          _colorSelectionCircle(
              index: 3, noteColor: NoteColor.yellow, notifier: notifier),
          _colorSelectionCircle(
              index: 4, noteColor: NoteColor.green, notifier: notifier),
          _colorSelectionCircle(
              index: 5, noteColor: NoteColor.lightBlue, notifier: notifier),
          _colorSelectionCircle(
              index: 6, noteColor: NoteColor.mediumBlue, notifier: notifier),
          _colorSelectionCircle(
              index: 7, noteColor: NoteColor.darkBlue, notifier: notifier),
          _colorSelectionCircle(
              index: 8, noteColor: NoteColor.purple, notifier: notifier),
          _colorSelectionCircle(
              index: 9, noteColor: NoteColor.pink, notifier: notifier),
          _colorSelectionCircle(
              index: 10, noteColor: NoteColor.brown, notifier: notifier),
          _colorSelectionCircle(
              index: 11, noteColor: NoteColor.grey, notifier: notifier),
          SizedBox(
            width: 6,
          )
        ],
      ),
    );
  }
}

class _CreateNoteBottomSheetTile extends StatelessWidget {
  final PngIcon pngIcon;

  final String text;

  final void Function() onTap;

  _CreateNoteBottomSheetTile(
      {@required this.pngIcon, @required this.text, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteEditingChangeNotifier>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 48,
        color: notifier.selectedColor.getColor(),
        width: double.infinity,
        padding: EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            pngIcon,
            SizedBox(
              width: 24,
            ),
            Text(text, style: bottomSheetStyle)
          ],
        ),
      ),
    );
  }
}
