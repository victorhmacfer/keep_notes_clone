import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/blocs/note_labeling_bloc.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/reminder_setup_dialog.dart';
import 'package:keep_notes_clone/models/reminder.dart';
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
        theAppBar = _NoteSetupAppBar();
      } else {
        controller = NoteSetupScreenController();
        theAppBar = _NoteSetupAppBar();
      }
    } else {
      controller = NoteSetupScreenController.fromNote(note);
      theAppBar = _NoteSetupAppBar();
    }

    return Hero(
      tag: 'notesetup-note-${note?.id}',
      flightShuttleBuilder: (context, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return DefaultTextStyle(
            style: DefaultTextStyle.of(toHeroContext).style,
            child: toHeroContext.widget);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NoteSetupScreenController>.value(
              value: controller),
          Provider<NoteSetupBloc>(
            create: (context) => NoteSetupBloc(repo),
          ),
        ],
        child: Scaffold(
            appBar: theAppBar,
            body: _NoteSetupBody(),
            bottomNavigationBar: _MyStickyBottomAppBar()),
      ),
    );
  }
}

class _NoteSetupAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);
    final noteSetupBloc = Provider.of<NoteSetupBloc>(context);

    bool shouldUnarchive = notifier.archived;

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: notifier.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGreyForColoredBg),
      leading: IconButton(
          key: ValueKey('note_setup_back'),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (notifier.canCreateNote) {
              if (notifier.creating) {
                noteSetupBloc.onCreateNote(notifier.noteBeingSetUp);
              } else {
                notifier.tryToUpdateLastEdited();
                noteSetupBloc.onNoteChanged(notifier.noteBeingSetUp);
              }
            }
            notifier.closeLeftBottomSheet();
            notifier.closeRightBottomSheet();
            Navigator.pop(context);
          }),
      actions: <Widget>[
        Padding(
          key: ValueKey('note_setup_pin_button'),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              backgroundColor: notifier.selectedColor.getColor(),
              pngIcon: (notifier.pinned)
                  ? PngIcon(
                      fileName: 'baseline_push_pin_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    )
                  : PngIcon(
                      fileName: 'outline_push_pin_black_48.png',
                      iconColor: appIconGreyForColoredBg,
                    ),
              onTap: () {
                notifier.togglePinned();
              }),
        ),
        Padding(
          key: ValueKey('note_setup_reminder_button'),
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
                      Provider(create: (context) => NoteSetupBloc(repo)),
                    ],
                    child: ReminderSetupDialog(),
                  ),
                );
              }),
        ),
        Padding(
          key: ValueKey('note_setup_archive_button'),
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
                if (notifier.canCreateNote) {
                  if (notifier.creating) {
                    noteSetupBloc.onCreateNote(notifier.noteBeingSetUp,
                        createArchived: true);
                  } else {
                    notifier.tryToUpdateLastEdited();
                    notifier.toggleArchived();
                    noteSetupBloc.onNoteChanged(notifier.noteBeingSetUp);
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

class _FiredReminderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      color: Colors.grey[700],
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Fired Today, 18:05',
            style: TextStyle(color: appWhite),
          ),
          Icon(Icons.check, color: appWhite),
        ],
      ),
    );
  }
}

class _NoteSetupBody extends StatelessWidget {
  List<Widget> _labelWidgets(List<Label> theLabels) {
    return theLabels.map((lab) => NoteSetupLabelChip(label: lab)).toList();
  }

  Widget _noteChips(Reminder savedReminder, List<Label> theLabels) {
    if (theLabels.isEmpty && (savedReminder == null)) {
      return Container();
    }
    List<Widget> chipList = [];

    if (savedReminder != null) {
      chipList.add(NoteSetupReminderChip(savedReminder));
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
              child: Visibility(
                child: _FiredReminderBanner(),
                visible: false,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding:
                      EdgeInsets.only(top: 24, bottom: 72, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        key: ValueKey('note_setup_title'),
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
                        key: ValueKey('note_setup_text'),
                        controller: notifier.textController,
                        focusNode: notifier.textFocusNode,
                        autofocus: notifier.creating,
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
                      _noteChips(notifier.savedReminder, noteLabels),
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
  String _noteSetupLastEditedText(DateTime lastEdited) {
    var now = DateTime.now();
    var dayToday = now.day;
    var monthToday = now.month;
    var yearToday = now.year;
    var yesterday = now.subtract(Duration(days: 1));

    String hourZeroOrNothing = (lastEdited.hour < 10) ? '0' : '';
    String minuteZeroOrNothing = (lastEdited.minute < 10) ? '0' : '';

    // if today... Edited 16:53
    if ((lastEdited.day == dayToday) &&
        (lastEdited.month == monthToday) &&
        (lastEdited.year == yearToday)) {
      return 'Edited $hourZeroOrNothing${lastEdited.hour}:$minuteZeroOrNothing${lastEdited.minute}';
    }

    if ((lastEdited.day == yesterday.day) &&
        (lastEdited.month == yesterday.month) &&
        (lastEdited.year == yesterday.year)) {
      return 'Edited Yesterday, $hourZeroOrNothing${lastEdited.hour}:$minuteZeroOrNothing${lastEdited.minute}';
    }

    return 'Edited ${monthAbbreviations[lastEdited.month]} ${lastEdited.day}';
  }

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
            key: ValueKey('right_bs_delete_button'),
            noteSetupController: notifier,
            pngIcon: PngIcon(
              fileName: 'outline_delete_black_48.png',
              iconColor: appIconGreyForColoredBg,
            ),
            text: 'Delete',
            onTap: () {
              notifier.deleteNote();
              if (notifier.editing) {
                noteSetupBloc.onNoteChanged(notifier.noteBeingSetUp);
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
            key: ValueKey('right_bs_labels_button'),
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
                                create: (context) => NoteLabelingBloc(repo),
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

    var lastEditedText = _noteSetupLastEditedText(notifier.lastEdited);

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
                    key: ValueKey('note_setup_right_bs_button'),
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
        key: ValueKey('note_setup_color_circle_${noteColor.colorDescription}'),
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
