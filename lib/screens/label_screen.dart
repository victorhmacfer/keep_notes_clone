import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/label_delete_confirmation.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/label_view_model.dart';
import 'package:provider/provider.dart';

class LabelScreen extends StatelessWidget {
  final Label label;

  LabelScreen(this.label);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MultiNoteSelection>(
      create: (context) => MultiNoteSelection(),
      child: Scaffold(
        backgroundColor: appWhite,
        extendBody: true,
        floatingActionButton: MyCustomFab(label: label),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyNotchedBottomAppBar(),
        drawer: MyDrawer(),
        body: _Body(label),
      ),
    );
  }
}

const double _bottomPadding = 56;

enum LabelMenuAction { renameLabel, deleteLabel }

class _Body extends StatefulWidget {
  final Label label;

  final TextEditingController labelRenamingController;

  _Body(this.label)
      : labelRenamingController = TextEditingController(text: label.name);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  String labelName;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    labelName = widget.label.name;
  }

  Widget _labelRenameDialog(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Text('Rename label'),
      titleTextStyle: cardTitleStyle,
      content: SizedBox(
        width: screenWidth * 0.7,
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Label name cannot be empty';
              }

              if (noteBloc.renameLabel(widget.label, value) == false) {
                return 'This label name is already in use';
              }
              return null;
            },
            controller: widget.labelRenamingController,
            textAlignVertical: TextAlignVertical.center,
            autofocus: true,
            cursorColor: NoteColor.orange.getColor(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appDividerGrey, width: 2)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appDividerGrey, width: 2)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2)),
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.fromLTRB(24, 16, 24, 0),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsPadding: EdgeInsets.fromLTRB(0, 16, 4, 0),
      buttonPadding: EdgeInsets.symmetric(horizontal: 8),
      actions: <Widget>[
        FlatButton(
          color: appWhite,
          onPressed: () {
            widget.labelRenamingController.text = labelName;
            Navigator.pop(context);
          },
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cancel',
            style: cardTitleStyle.copyWith(fontSize: 14),
          ),
        ),
        FlatButton(
          color: NoteColor.orange.getColor(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop<String>(
                  context, widget.labelRenamingController.text);
            }
          },
          child: Text(
            'Rename',
            style: cardTitleStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _selectNoteCardModeButton(NoteCardModeSelection notifier) {
    if (notifier.mode == NoteCardMode.extended) {
      return PngIconButton(
          backgroundColor: appWhite,
          padding: EdgeInsets.symmetric(horizontal: 8),
          pngIcon: PngIcon(
            fileName: 'outline_dashboard_black_48.png',
          ),
          onTap: () {
            notifier.switchTo(NoteCardMode.small);
          });
    }
    return PngIconButton(
        backgroundColor: appWhite,
        padding: EdgeInsets.symmetric(horizontal: 8),
        pngIcon: PngIcon(
          fileName: 'outline_view_agenda_black_48.png',
        ),
        onTap: () {
          notifier.switchTo(NoteCardMode.extended);
        });
  }

  Widget _sliverAppBar(
      {@required NoteTrackingBloc noteBloc,
      @required NoteCardModeSelection cardModeNotifier,
      @required DrawerScreenSelection drawerScreenSelection}) {
    return SliverAppBar(
      floating: true,
      backgroundColor: appWhite,
      iconTheme: IconThemeData(color: appIconGrey),
      title: Text(
        labelName,
        style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: PngIconButton(
              backgroundColor: appWhite,
              padding: EdgeInsets.symmetric(horizontal: 8),
              pngIcon: PngIcon(fileName: 'baseline_search_black_48.png'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteSearchScreen()));
              }),
        ),
        _selectNoteCardModeButton(cardModeNotifier),
        PopupMenuButton<LabelMenuAction>(
          onSelected: (action) async {
            if (action == LabelMenuAction.renameLabel) {
              var newName = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: _labelRenameDialog,
              );
              if (newName?.isNotEmpty ?? false) {
                setState(() {
                  labelName = newName;
                });
              }
            } else if (action == LabelMenuAction.deleteLabel) {
              var shouldDelete = await showDialog<bool>(
                barrierDismissible:
                    true, // "shouldDelete" might be null as well.
                context: context,
                builder: deleteConfirmationDialog,
              );
              if (shouldDelete) {
                drawerScreenSelection.changeSelectedScreenToIndex(0);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));

                noteBloc.onDeleteLabel(widget.label);
              }
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => <PopupMenuEntry<LabelMenuAction>>[
            PopupMenuItem<LabelMenuAction>(
              value: LabelMenuAction.renameLabel,
              child: Text('Rename label'),
            ),
            PopupMenuItem<LabelMenuAction>(
              value: LabelMenuAction.deleteLabel,
              child: Text('Delete label'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var noteCardModeNotifier = Provider.of<NoteCardModeSelection>(context);
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var drawerScreenSelection = Provider.of<DrawerScreenSelection>(context);

    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    return SafeArea(
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              (multiNoteSelection.inactive)
                  ? _sliverAppBar(
                      noteBloc: noteBloc,
                      cardModeNotifier: noteCardModeNotifier,
                      drawerScreenSelection: drawerScreenSelection)
                  : MultiNoteSelectionAppBar(multiNoteSelection),
              SliverToBoxAdapter(
                child: _StreamBuilderBody(),
              ),
            ],
          ),
        ));
  }
}

class _StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<LabelViewModel>(
        stream: noteBloc.labelViewModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pinnedNotes = snapshot.data.pinned;
            var unpinnedNotes = snapshot.data.unpinned;
            var archivedNotes = snapshot.data.archived;

            var hasAnyNote = pinnedNotes.isNotEmpty ||
                unpinnedNotes.isNotEmpty ||
                archivedNotes.isNotEmpty;

            var onlyHasUnpinnedNotes =
                hasAnyNote && (pinnedNotes.isEmpty && archivedNotes.isEmpty);

            if (hasAnyNote) {
              if (onlyHasUnpinnedNotes) {
                return Container(
                  margin: EdgeInsets.only(bottom: _bottomPadding),
                  child: OptionalSection(
                    mode: modeNotifier.mode,
                    noSpacer: true,
                    notes: unpinnedNotes,
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(bottom: _bottomPadding),
                child: Column(
                  children: <Widget>[
                    OptionalSection(
                      title: 'PINNED',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: pinnedNotes,
                    ),
                    OptionalSection(
                      title: 'OTHERS',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: unpinnedNotes,
                    ),
                    OptionalSection(
                      title: 'ARCHIVED',
                      mode: modeNotifier.mode,
                      notes: archivedNotes,
                      noSpacer: true,
                    ),
                  ],
                ),
              );
            }
            return NoLabelsScreen();
          }
          return Container();
        });
  }
}
