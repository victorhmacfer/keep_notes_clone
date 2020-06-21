import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/bottomsheet_tile.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:provider/provider.dart';

class DeletedNoteSetupScreen extends StatelessWidget {
  final Note note;

  DeletedNoteSetupScreen({@required this.note});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteSetupScreenController>(
      create: (context) => NoteSetupScreenController.fromNote(note),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: notifier.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGrey),
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

    return Container(
      color: notifier.selectedColor.getColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'baseline_restore_black_48.png'),
            text: 'Restore',
            onTap: () {},
          ),
          BottomSheetTile(
            noteSetupController: notifier,
            pngIcon: PngIcon(fileName: 'baseline_delete_forever_black_48.png'),
            text: 'Delete forever',
            onTap: () {},
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
                    pngIcon: PngIcon(
                      fileName: 'outline_add_box_black_48.png',
                      iconColor: appGreyForColoredBg,
                    ),
                    onTap: () {}),
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
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
